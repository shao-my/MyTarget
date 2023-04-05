//
//  TimerScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/20.
//

import SwiftUI
import CoreData

enum TimeTab: String {
    case time = "时间线"
    case view = "统计图"
}

struct TimerScreen: View {
    @State var animationCalendar: [Bool] = Array(repeating: false, count: 2)
    @State var calendarHeight: CGFloat = 0
    @Namespace var animation
    
    @State var animationTopView: Bool = false
    @State var currentDate: Date = Date()
    
    
    @FetchRequest(entity: DayBook.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.id, ascending: false)], predicate: NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date())), animation: .easeInOut)
    var dayBookList: FetchedResults<DayBook>
    // @State var dayBookList: [DayBook] = []
    @StateObject var dayBookModel: DayBookModel = DayBookModel()
    // @EnvironmentObject var dayBookModel: DayBookModel = DayBookModel()
    @State var dayBookListForState: [DayBook] = []
    
    @State var isFlod: Bool = true
    
    @State private var currentTab: TimeTab = .time
    @State private var shakeValue: CGFloat = 0
    
    let themeColor: Color = Color(red: 49 / 255, green: 38 / 255, blue: 126 / 255)
    
    
    @State var holdProgress: Double = 0.0
    @State var quitProgress: Double = 0.0
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical ,showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        GeometryReader { proxy in
                            let maxY = proxy.frame(in: .global).maxY
                            
                            CustomDatePicker(currentDate: $currentDate,dayBookListForState: $dayBookListForState)
                                .background {
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .fill(Color(red: 49 / 255, green: 38 / 255, blue: 126 / 255))
                                    //.matchedGeometryEffect(id: "Calender", in: animation)
                                }
                                .rotation3DEffect(.init(degrees: animationTopView ? 0 : -270), axis: (x: 1, y: 0, z: 0), anchor: .center)
                                .offset(y: animationTopView ? 0 : -maxY)
                        }
                        .frame(height: 360)
                    }
                    .onAppear {
                        animateTopButton()
                        dayBookListForState = dayBookList.reversed()
                    }
                    .onDisappear{
                        animationTopView.toggle()
                    }
                    .padding([.horizontal,.top])
                    .frame(maxHeight: .infinity,alignment: .top)
                    
                    
                    SegmentedControl()
                    
                    ZStack {
                        if currentTab == .time {
                            VStack{
                                TimeLineView()
                            }
                            .padding([.horizontal,.top])
                            .onAppear(){
                                startAnimation()
                            }
                        }
                        
                        if currentTab == .view {
                            //进度圈
                            VStack {
                                VStack {
                                    GeometryReader { (geometry) in
                                        makeCircle(geometry,holdProgress: holdProgress,quitProgress: quitProgress)
                                    }
                                }
                                .padding()
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                                .frame(maxWidth: .infinity,minHeight: 200)
                                .padding()
                                .onChange(of: dayBookListForState) { newValue in
                                    holdProgress = getDayBookPercent(dayBooks: dayBookListForState, quartzType: "HOLD")
                                    quitProgress = getDayBookPercent(dayBooks: dayBookListForState, quartzType: "QUIT")
                                }
                                .onAppear {
                                    holdProgress = getDayBookPercent(dayBooks: dayBookListForState, quartzType: "HOLD")
                                    quitProgress = getDayBookPercent(dayBooks: dayBookListForState, quartzType: "QUIT")
                                }
                                //hold汇总  quit汇总
                                //hold连续
                                HStack(spacing: 20){
                                    VStack(spacing: 10) {
                                        HStack(spacing: 20) {
                                            Text("恒之")
                                                .font(.title3.bold())
                                                .padding(.bottom, 4)
                                                .foregroundColor(Color.accentColor)
                                                .push(to: .leading)
                                            
                                            
                                            
                                            HStack(spacing: 10) {
                                                Text("完成率")
                                                    .font(.callout.bold())
                                                
                                                Text("\(String(format: "%.2f", holdProgress * 100)) %")
                                                    .font(.title3.bold())
                                                    .foregroundColor(holdProgress >= 1 ? Color.green : Color.red)
                                            }
                                        }
                                        
                                        HStack (spacing: 20){
                                            HStack(spacing: 10) {
                                                Text("目标数量")
                                                    .font(.callout.bold())
                                                
                                                
                                                Text("\(getDayBookSumCount(dayBooks: dayBookListForState, quartzType: "HOLD")) 个")
                                                    .font(.callout.bold())
                                            }
                                            
                                            Spacer()
                                            
                                        }
                                        
                                        HStack (spacing: 20){
                                            
                                            HStack(spacing: 10) {
                                                Text("完成数量")
                                                    .font(.callout.bold())
                                                
                                                Text("\(getDayBookCompletedCount(dayBooks: dayBookListForState, quartzType: "HOLD")) 个")
                                                    .font(.callout.bold())
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        
                                        
                                        HStack (spacing: 20){
                                            HStack(spacing: 10) {
                                                Text("耗时时长")
                                                    .font(.callout.bold())
                                                
                                                Text("\(getDayBookCompletedTime(dayBooks: dayBookListForState, quartzType: "HOLD"))")
                                                    .font(.callout.bold())
                                                
                                                Spacer()
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity).background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.bg2)
                                    }
                                    
                                }
                                .padding([.horizontal,.top])
                                
                                HStack(spacing: 20){
                                    VStack(spacing: 10) {
                                        HStack(spacing: 20) {
                                            Text("誡之")
                                                .font(.title3.bold())
                                                .padding(.bottom, 4)
                                                .foregroundColor(Color.red)
                                                .push(to: .leading)
                                            
                                            
                                            
                                            HStack(spacing: 10) {
                                                Text("完成率")
                                                    .font(.callout.bold())
                                                
                                                Text("\(String(format: "%.2f", quitProgress * 100)) %")
                                                    .font(.title3.bold())
                                                    .foregroundColor(quitProgress >= 1 ? Color.green : Color.red)
                                            }
                                        }
                                        
                                        HStack (spacing: 20){
                                            HStack(spacing: 10) {
                                                Text("目标数量")
                                                    .font(.callout.bold())
                                                
                                                
                                                Text("\(getDayBookSumCount(dayBooks: dayBookListForState, quartzType: "QUIT")) 个")
                                                    .font(.callout.bold())
                                            }
                                            
                                            Spacer()
                                            
                                        }
                                        
                                        HStack (spacing: 20){
                                            
                                            HStack(spacing: 10) {
                                                Text("完成数量")
                                                    .font(.callout.bold())
                                                
                                                Text("\(getDayBookCompletedCount(dayBooks: dayBookListForState, quartzType: "QUIT")) 个")
                                                    .font(.callout.bold())
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        
                                        
                                        HStack (spacing: 20){
                                            HStack(spacing: 10) {
                                                Text("耗时时长")
                                                    .font(.callout.bold())
                                                
                                                Text("\(getDayBookCompletedTime(dayBooks: dayBookListForState, quartzType: "QUIT"))")
                                                    .font(.callout.bold())
                                                
                                                Spacer()
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity).background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.bg2)
                                    }
                                    
                                }
                                .padding(.horizontal)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func SegmentedControl() -> some View {
        HStack(spacing: 0) {
            TapableText(.time)
                .foregroundColor(themeColor)
                .overlay {
                    CustomCorner(corners: [.topLeft,.bottomLeft], radius: 50)
                        .fill(themeColor)
                        .overlay {
                            TapableText(.view)
                                .foregroundColor(currentTab == .view ? .white : .clear)
                                .scaleEffect(x: -1)
                        }
                        .overlay {
                            TapableText(.time)
                                .foregroundColor(currentTab == .view ? .clear : .white)
                        }
                        .rotation3DEffect(.init(degrees: currentTab == .time ? 0 : 180), axis: (x: 0, y: 1, z: 0),anchor: .trailing, perspective: 0.45)
                    
                }
                .zIndex(1)
                .contentShape(Rectangle())
            
            TapableText(.view)
                .foregroundColor(themeColor)
                .zIndex(0)
        }
        .background {
            ZStack {
                Capsule()
                    .fill(.white)
                
                Capsule()
                    .stroke(themeColor, lineWidth: 1)
            }
        }
        .rotation3DEffect(.init(degrees: shakeValue), axis: (x: 0, y: 1, z: 0))
    }
    
    @ViewBuilder
    func TapableText(_ tab: TimeTab) -> some View {
        Text(tab.rawValue)
            .font(.callout.bold())
            .contentTransition(.interpolate)
            .padding(.vertical, 12)
            .padding(.horizontal, 40)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)){
                    currentTab = tab
                }
                
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                    shakeValue = (tab == .view ? 10 : -10)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                        shakeValue = 0
                    }
                }
            }
        
    }
    
    @ViewBuilder
    func TimeLineView() -> some View {
        ScrollViewReader{ proxy in
            let hours = getHoursInDay(date: currentDate)
            //let midHour = hours[0]
            /*$dayBookList.wrappedValue.count
             let startTime = $dayBookList.wrappedValue.first?.startTime
             midHour = hours.firstIndex(of: 0)
             */
            //let midHour = hours[hours.count / 2]
            
            VStack {
                ForEach(hours, id: \.self){ hour in
                    TimelineViewRow(isFlod: $isFlod ,date: hour, index: hours.firstIndex(of: hour)!)
                        .id(hour)
                }
            }
            /* .onAppear {
             currentDate = Date()
             proxy.scrollTo(midHour)
             }*/
        }
    }
    
    
    func getIndex(dayBook: DayBook) -> Int {
        return dayBookList.firstIndex { currentDayBook in
            return dayBook.id == currentDayBook.id
        } ?? 0
    }
    
    func startAnimation(){
        calendarHeight = 300
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.7)){
                animationCalendar[0] = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            animationCalendar[1] = true
        }
    }
    
    func animateTopButton(){
        withAnimation(.interactiveSpring(response: 1.3, dampingFraction:  0.7)){
            animationTopView = true
        }
    }
}



struct TimelineViewRow: View {
    @Binding var isFlod: Bool
    @State var date: Date
    //@Binding var dayBookList: [DayBook]
    @State var index: Int
    @State var showCardView: Bool = false
    @Environment(\.self) var env
    @StateObject var dayBookModel: DayBookModel = DayBookModel()
    
    /*@FetchRequest(entity: DayBook.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.id, ascending: false)], predicate: NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date())), animation: .easeInOut)
    var dayBookList: FetchedResults<DayBook>*/
    
    @State  var dayBookList: [DayBook] = []
    
    var body: some View {
        let calendar = Calendar.current
        let finishedBook =  dayBookModel.dayBookList.filter {
            if let hour = calendar.dateComponents([.hour], from: date).hour,
               let bookHour = calendar.dateComponents([.hour], from:  $0.startTime!).hour,
               hour == bookHour && calendar.isDate(getDateForYYYYMMDD(dateTime: $0.dayTime!), inSameDayAs: date){
                return true
            }
            return false
        }
        
        HStack(alignment: .top) {
            Text(date.dateToString("h a"))
                .font(.caption).fontWeight(.regular)
                .frame(width: 45, alignment: .leading)
            
            if finishedBook.isEmpty {
                Rectangle()
                    .stroke(.bg2,style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y: 10)
            }else{
                VStack(spacing: 10) {
                    ForEach(finishedBook, id: \.self){ book in
                        BookRow(book)
                    }
                }
            }
        }
        .push(to: .leading)
        .padding(.vertical, finishedBook.isEmpty && isFlod ? 0 : 15)
        .offset(y: showCardView ? 0 : 450)
        .onAppear {
            dayBookModel.dayBookList = dayBookModel.fetchDayBookForDay(context: env.managedObjectContext,date: date)
            withAnimation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1)) {
                showCardView = true
            }
        }
        .onDisappear {
            showCardView = false
        }
    }
    
    @ViewBuilder
    func BookRow(_ book: DayBook) -> some View {
        let color = Color(SYSColor(rawValue: book.quartzColor ?? "gray")!.create)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 10){
                    ZStack{
                        Image(systemName: book.quartzIcon ?? "def")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .bold()
                            .foregroundColor(.white)
                            .zIndex(999)
                        
                        Circle()
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color(SYSColor(rawValue: book.quartzColor ?? "gray")!.create))
                        
                    }
                    
                    Text(book.quartzName!)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(color)
                }
                
                Spacer(minLength: 0)
                
              
                HStack {
                    let scoreValue =  book.quartzTimes < 10 ? "0\(book.completedTimes)" : "\(book.completedTimes)"
                    
                    Text(scoreValue)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .roundedRectBackground(radius: 8, fill: book.quartzType == "HOLD" ? Color.accentColor.opacity(0.6) : Color.red.opacity(0.6))
                    
                    let totalValue =  book.quartzTimes < 10 ? "0\(book.quartzTimes)" : "\(book.quartzTimes)"
                    
                    Text(totalValue)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .roundedRectBackground(radius: 8, fill: .secondary)
                }
                .opacity(book.quartzWay == "TIMES" && book.isCompleted == false ? 1 : 0)
              
                Image(systemName: book.isCompleted ? "checkmark" : "xmark")
                    .padding()
                    .frame(width: 28, height: 28)
                    .bold()
                    .foregroundColor(.white)
                    .roundedRectBackground(radius: 100, fill: book.isCompleted ? Color(.systemGreen) : Color(.systemGray))
                    .opacity(book.quartzWay == "TIMES" && book.isCompleted == false ? 0 : 1)
               
                
                if (book.isCompleted == false && !isSameDay(date1: date, date2: Date())){
                    Button {
                        book.isCompleted.toggle()
                        if book.isCompleted {
                            book.finishedTime = Date()
                        }else{
                            book.finishedTime = nil
                        }
                        if book.quartzWay == "TIMES" {
                            book.completedTimes = book.quartzTimes
                        }
                        //打卡，更新状态
                        try? env.managedObjectContext.save()
                        dayBookModel.dayBookList = dayBookModel.fetchDayBookForDay(context: env.managedObjectContext,date: date)
                    } label: {
                        Text("补卡")
                            .font(.callout.bold())
                            .foregroundColor(.white)
                    }
                    .frame(width: 40, height: 28)
                    .roundedRectBackground(radius: 10, fill: Color.accentColor)
                }
            }
            .padding(.horizontal, 4)
            
            if (book.isCompleted) {
                VStack(alignment: .leading,spacing: 10){
                    Text("完成时间: \(book.finishedTime!.dateToString("h a"))")
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                    
                    
                    Text("耗时时长: \(getTimeDifference(time1:  book.startTime!, time2:  book.finishedTime!))")
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                }
                .padding(.horizontal, 4)
            }
            
        }
        .push(to: .leading)
        .padding(12)
        .background {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.bg2)
                    .cornerRadius(8)
                
                Rectangle()
                    .fill(color)
                    .frame(width: 4)
            }
        }
    }
}

struct TimerScreen_Previews: PreviewProvider {
    static var previews: some View {
        TimerScreen()
    }
}
