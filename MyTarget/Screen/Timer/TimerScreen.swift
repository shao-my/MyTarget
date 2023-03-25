//
//  TimerScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/20.
//

import SwiftUI
import CoreData

struct TimerScreen: View {
   // @StateObject public var coreDataModel = CoreDataModel()
   // @EnvironmentObject public var coreDataModel : CoreDataModel
    @State var animationCalendar: [Bool] = Array(repeating: false, count: 2)
    @State var calendarHeight: CGFloat = 0
    @Namespace var animation
    
    @State var animationTopView: Bool = false
    @State var currentDate: Date = Date()
     
    
    @FetchRequest(entity: DayBook.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.startTime, ascending: false)], predicate: NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date())), animation: .easeInOut)  
    private var dayBookList: FetchedResults<DayBook>
   // @State var dayBookList: [DayBook] = []
    @Environment(\.self) var env
    @StateObject var dayBookModel: DayBookModel = DayBookModel()
    @State var dayBookListForState: [DayBook] = []
    
    var body: some View {
        NavigationView {
            VStack {
                /* if !animationCalendar[1]{
                 RoundedRectangle(cornerRadius: 0, style: .continuous)
                 .fill(Color(.systemIndigo))
                 .matchedGeometryEffect(id: "Calender", in: animation)
                 //.frame(height: calendarHeight)
                 .ignoresSafeArea()
                 
                 }*/
                 
                VStack(spacing: 0) {
                    /*Button {
                     
                     } label: {
                     SFSymbol.info
                     .font(.title3)
                     }
                     .push(to: .trailing)
                     .overlay {
                     Text("时间")
                     .font(.title3)
                     .fontWeight(.semibold)
                     }
                     .padding(.bottom, 30)
                     */
                    GeometryReader { proxy in
                        let maxY = proxy.frame(in: .global).maxY
                        
                        CustomDatePicker(currentDate: $currentDate,dayBookList: dayBookList.reversed(),dayBookListForState: $dayBookListForState)
                            .background {
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .fill(Color(red: 49 / 255, green: 38 / 255, blue: 126 / 255))
                                //.matchedGeometryEffect(id: "Calender", in: animation)
                            }
                            .rotation3DEffect(.init(degrees: animationTopView ? 0 : -270), axis: (x: 1, y: 0, z: 0), anchor: .center)
                            .offset(y: animationTopView ? 0 : -maxY)
                    }
                    .frame(height: 60)
                }.onAppear {
                   // coreDataModel.fetchDayBook()
                   // dayBookList = coreDataModel.dayBooks
                   // print(coreDataModel.dayBooks)
                    animateTopButton()
                    dayBookListForState = dayBookList.reversed()
                    print(dayBookListForState)
                }
                .onDisappear{
                    animationTopView.toggle()
                }
                .padding([.horizontal,.top])
                .frame(maxHeight: .infinity,alignment: .top)
                
                ScrollView(.vertical ,showsIndicators: false) {
                    TimeLineView()
                }
                .padding(.horizontal)
                .padding(.top, -40)
                .onAppear(){
                    startAnimation()
                }
            }
        }
    }
    
    @ViewBuilder
    func TimeLineView() -> some View {
        ScrollViewReader{ proxy in
            let hours = getHoursInDay(date: currentDate)
        
            var midHour = hours[0]
            /*$dayBookList.wrappedValue.count
             let startTime = $dayBookList.wrappedValue.first?.startTime
             midHour = hours.firstIndex(of: 0)
             */
            //let midHour = hours[hours.count / 2]
          
            VStack {
                ForEach(hours, id: \.self){ hour in
                    TimelineViewRow(date: hour,dayBookList: $dayBookListForState,index: hours.firstIndex(of: hour)!)
                        .id(hour)
                }
            }
            .onAppear {
                proxy.scrollTo(midHour)
            }
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
    @State var date: Date
    @Binding var dayBookList: [DayBook]
    @State var index: Int
    @State var showCardView: Bool = false
    var body: some View {
        HStack(alignment: .top) {
            Text(date.dateToString("h a"))
                .font(.caption).fontWeight(.regular)
                .frame(width: 45, alignment: .leading)
            
            let calendar = Calendar.current
            let finishedBook = dayBookList.filter {
                if let hour = calendar.dateComponents([.hour], from: date).hour,
                   let bookHour = calendar.dateComponents([.hour], from:  $0.startTime!).hour,
                   hour == bookHour && calendar.isDate(getDateForYYYYMMDD(dateTime: $0.dayTime!), inSameDayAs: date){
                    return true
                }
                return false
            }
            
            if finishedBook.isEmpty {
                Rectangle()
                    .stroke(.bg2,style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
                    .offset(y: 10)
            }else{
                VStack(spacing: 10) {
                    ForEach(finishedBook){ book in
                        BookRow(book)
                    }
                }
            }
        }
        .push(to: .leading)
        .padding(.vertical, 15)
        .offset(y: showCardView ? 0 : 450)
        .onAppear {
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
                
                if (book.quartzWay == "TIMES" && book.isCompleted == false) {
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
                }else{
                    Image(systemName: book.isCompleted ? "checkmark" : "xmark")
                        .padding()
                        .frame(width: 28, height: 28)
                        .bold()
                        .foregroundColor(.white)
                        .roundedRectBackground(radius: 100, fill: book.isCompleted ? Color(.systemGreen) : Color(.systemGray))
                        
                    
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
