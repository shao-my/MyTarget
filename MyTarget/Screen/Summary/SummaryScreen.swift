//
//  SummaryView.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
import CoreData 

struct SummaryScreen: View {
    // @StateObject public var coreDataModel = CoreDataModel()
    //@EnvironmentObject public var coreDataModel : CoreDataModel
    @State private var sheet: Sheet?
    //private var isAddHoldQuartz: Bool  { dayBookList.count == 0 }
    
    //@Environment(\.managedObjectContext) var coreDataContext
    
    @State var holdProgress: Double = 0.0
    @State var flipHoldScore  = false
    @State var holdFrontDegrees: Double = 0.0
    @State var holdBackDegrees: Double = -180.0
    
    @State var quitProgress: Double = 0.0
    @State var flipQuitScore  = false
    @State var quitFrontDegrees: Double = 0.0
    @State var quitBackDegrees: Double = -180.0
    
    @State var bookSize = 80.0
    @State var scale: CGFloat = 1
    @State var showDetail = false
    @State var holdSummaryStr: String = "00 / 00"
    @State var holdScoreNumber: Int =  0
    @State var holdTotalNumber: Int =  0
    @State var quitSummaryStr: String = "00 / 00"
    @State var quitScoreNumber: Int =  0
    @State var quitTotalNumber: Int =  0
    @State var animationScore: Bool = false
    
    @StateObject var quartzModel: QuartzModel = QuartzModel()
    @StateObject var dayBookModel: DayBookModel = DayBookModel()
    
    @Environment(\.self) var env
    
    @FetchRequest(entity: DayBook.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.startTime, ascending: false)], predicate: NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date())), animation: .easeInOut)
    private var dayBookList: FetchedResults<DayBook>
    
    @State var isShowHoldSheet: Bool = false
    @State var isShowQuitSheet: Bool = false

    
    func addHoldQuartz(prms: QuartzPrms) -> Void {
        quartzModel.addQuartz(context: env.managedObjectContext, quartzPrms: prms)
        holdSummaryStr = getDayBookSummary(dayBooks:  dayBookList.reversed(), quartzType: "HOLD")
        holdProgress = getDayBookPercent(dayBooks:  dayBookList.reversed(), quartzType: "HOLD")
        flipHoldScore.toggle()
        holdFrontDegrees = holdFrontDegrees + 180
        holdTotalNumber = Int(holdSummaryStr.suffix(2))!
    }
    
    func addQuitQuartz(prms: QuartzPrms) -> Void {
        quartzModel.addQuartz(context: env.managedObjectContext, quartzPrms: prms)
        quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
        quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
        flipQuitScore.toggle()
        quitFrontDegrees = quitFrontDegrees + 180
        quitTotalNumber = Int(quitSummaryStr.suffix(2))!
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    Text("記之")
                        .font(.title3.bold())
                        .push(to: .leading)
                    
                    HStack {
                        VStack(spacing: 8){
                            VStack (spacing: 16){
                                Text("心以舟施,恒也。")
                                    .font(.subheadline)
                                
                                FlipScore(frontStr: $holdSummaryStr, backStr: $holdSummaryStr, flipped: $flipHoldScore, frontDegrees: $holdFrontDegrees, backDegrees: $holdBackDegrees, scoreColor: Color.accentColor,scoreValue: $holdScoreNumber ,totalValue: $holdTotalNumber)
                                    .push(to: .center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity).background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.bg2)
                            }
                            
                            
                            VStack (spacing: 16){
                                Text("戒，警也。")
                                    .font(.subheadline)
                                
                                FlipScore(frontStr: $quitSummaryStr, backStr: $quitSummaryStr, flipped: $flipQuitScore, frontDegrees: $quitFrontDegrees, backDegrees: $quitBackDegrees, scoreColor: Color.red,scoreValue: $quitScoreNumber , totalValue: $quitTotalNumber)
                                    .push(to: .center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity).background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.bg2)
                            }
                        }
                        
                        VStack {
                            GeometryReader { (geometry) in
                                makeCircle(geometry,holdProgress: holdProgress,quitProgress: quitProgress)
                            }
                        }
                        .padding()
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity,maxHeight: .infinity).background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.bg2)
                        }
                    }
                    .onAppear {
                        /*holdSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                         quitSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                         holdProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                         quitProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                         holdTotalNumber = Int(holdSummaryStr.suffix(2))!
                         quitTotalNumber = Int(quitSummaryStr.suffix(2))!
                         holdScoreNumber = Int(holdSummaryStr.prefix(2))!
                         quitScoreNumber = Int(quitSummaryStr.prefix(2))!*/
                        
                        holdSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
                        quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                        holdProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
                        quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                        holdTotalNumber = Int(holdSummaryStr.suffix(2))!
                        quitTotalNumber = Int(quitSummaryStr.suffix(2))!
                        holdScoreNumber = Int(holdSummaryStr.prefix(2))!
                        quitScoreNumber = Int(quitSummaryStr.prefix(2))!
                    }
                    
                    
                    ZStack {
                        Text("恒之")
                            .font(.title3.bold())
                            .push(to: .leading)
                    }
                    .padding(.top)
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                
                                ForEach(dayBookList) { book in
                                    if book.quartzType == "HOLD" {
                                        if book.quartzWay == "TIMES" {
                                            FlipIconByTimes(dayBook: book,flipped: book.isCompleted, total: Int(book.quartzTimes),times: Int(book.completedTimes))
                                                .simultaneousGesture(
                                                    TapGesture().onEnded{
                                                        //重置次数
                                                        if book.isCompleted {
                                                            book.completedTimes  = 0
                                                            book.isCompleted.toggle()
                                                            flipHoldScore.toggle()
                                                            holdFrontDegrees = holdFrontDegrees + 180
                                                        }else {
                                                            if(book.completedTimes + 1 < book.quartzTimes){
                                                            }else{
                                                                flipHoldScore.toggle()
                                                                holdFrontDegrees = holdFrontDegrees + 180
                                                                book.isCompleted.toggle()
                                                            }
                                                            book.completedTimes = book.completedTimes + 1
                                                        }
                                                        if book.isCompleted {
                                                            book.finishedTime = Date()
                                                        }else{
                                                            book.finishedTime = nil
                                                        }
                                                        /* holdSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                                                         holdProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                                                         coreDataModel.saveDayBook()
                                                         holdScoreNumber = Int(holdSummaryStr.prefix(2))!*/
                                                        holdSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
                                                        holdProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
                                                        try?  env.managedObjectContext.save()
                                                        holdScoreNumber = Int(holdSummaryStr.prefix(2))!
                                                    }
                                                )
                                        }
                                        else{
                                            FlipIcon(dayBook: book,flipped: book.isCompleted)
                                                .simultaneousGesture(
                                                    TapGesture().onEnded{
                                                        book.isCompleted.toggle()
                                                        if book.isCompleted {
                                                            book.finishedTime = Date()
                                                        }else{
                                                            book.finishedTime = nil
                                                        }
                                                        //打卡，更新状态
                                                        try?  env.managedObjectContext.save()
                                                        holdSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
                                                        holdProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
                                                        flipHoldScore.toggle()
                                                        holdFrontDegrees = holdFrontDegrees + 180
                                                        holdScoreNumber = Int(holdSummaryStr.prefix(2))!
                                                        //  coreDataModel.fetchDayBook(day: Date())
                                                        
                                                        
                                                    }
                                                )
                                        }
                                    }
                                }
                                
                                Text("+")
                                    .font(.body.bold())
                                    .frame(width: bookSize, height: bookSize)
                                    .roundedRectBackground(radius: bookSize,fill: .bg2)
                                    .onTapGesture {
                                        /*sheet = .newQuartzHold() {
                                            //新增Quartz，同时插入DayBook
                                            quartzModel.addQuartz(context: env.managedObjectContext, quartzPrms: $0)
                                            holdSummaryStr = getDayBookSummary(dayBooks:  dayBookList.reversed(), quartzType: "HOLD")
                                            holdProgress = getDayBookPercent(dayBooks:  dayBookList.reversed(), quartzType: "HOLD")
                                            flipHoldScore.toggle()
                                            holdFrontDegrees = holdFrontDegrees + 180
                                            holdTotalNumber = Int(holdSummaryStr.suffix(2))!
                                        }*/
                                        isShowHoldSheet.toggle()
                                    }
                            }
                        }
                    }
                    
                    Text("誡之")
                        .font(.title3.bold())
                        .padding(.top)
                        .push(to: .leading)
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(dayBookList) { book in
                                    if book.quartzType == "QUIT" {
                                        if book.quartzWay == "TIMES" {
                                            FlipIconByTimes(dayBook: book,flipped: book.isCompleted, total: Int(book.quartzTimes),times: Int(book.completedTimes))
                                                .simultaneousGesture(
                                                    TapGesture().onEnded{
                                                        //重置次数
                                                        if book.isCompleted {
                                                            book.completedTimes  = 0
                                                            book.isCompleted.toggle()
                                                            flipQuitScore.toggle()
                                                            quitFrontDegrees = quitFrontDegrees + 180
                                                        }else {
                                                            if(book.completedTimes + 1 < book.quartzTimes){
                                                            }else{
                                                                flipQuitScore.toggle()
                                                                quitFrontDegrees = quitFrontDegrees + 180
                                                                book.isCompleted.toggle()
                                                            }
                                                            book.completedTimes = book.completedTimes + 1
                                                        }
                                                        if book.isCompleted {
                                                            book.finishedTime = Date()
                                                        }else{
                                                            book.finishedTime = nil
                                                        }
                                                        /*    quitSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                         quitProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                         coreDataModel.saveDayBook()
                                                         quitScoreNumber = Int(quitSummaryStr.prefix(2))!*/
                                                        quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                                                        quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                                                        try?  env.managedObjectContext.save()
                                                        quitScoreNumber = Int(quitSummaryStr.prefix(2))!
                                                    }
                                                )
                                            
                                        }else{
                                            FlipIcon(dayBook: book,flipped: book.isCompleted)
                                                .simultaneousGesture(
                                                    TapGesture().onEnded{
                                                        book.isCompleted.toggle()
                                                        if book.isCompleted {
                                                            book.finishedTime = Date()
                                                        }else{
                                                            book.finishedTime = nil
                                                        }
                                                        /*   coreDataModel.saveDayBook()
                                                         quitSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                         quitProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                         flipQuitScore.toggle()
                                                         quitFrontDegrees = quitFrontDegrees + 180
                                                         quitScoreNumber = Int(quitSummaryStr.prefix(2))!*/
                                                        try?  env.managedObjectContext.save()
                                                        quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                                                        quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                                                        flipQuitScore.toggle()
                                                        quitFrontDegrees = quitFrontDegrees + 180
                                                        quitScoreNumber = Int(quitSummaryStr.prefix(2))!
                                                    }
                                                )
                                        }
                                    }
                                }
                                
                                Text("+")
                                    .font(.body.bold())
                                    .frame(width: bookSize, height: bookSize)
                                    .roundedRectBackground(radius: bookSize,fill: .bg2)
                                    .onTapGesture {
                                        /*sheet = .newQuartzQuit() {
                                            quartzModel.addQuartz(context: env.managedObjectContext, quartzPrms: $0)
                                            quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                                            quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
                                            flipQuitScore.toggle()
                                            quitFrontDegrees = quitFrontDegrees + 180
                                            quitTotalNumber = Int(quitSummaryStr.suffix(2))!
                                        }*/
                                        isShowQuitSheet.toggle()
                                    }
                                
                            }
                            .font(.title)
                        }
                    }
                    
                    Text("勉之")
                        .font(.title3.bold())
                        .padding(.top)
                        .push(to: .leading)
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitle(Text("概要"), displayMode: .automatic)
            .navigationBarItems(
                leading:
                    Text(getMonthDayWeek())
                    .font(.subheadline.bold())
                    .foregroundColor(Color(.systemGray))
            )
        } 
       // .sheet(item: $sheet){ $0 }
        .sheet(isPresented: $isShowHoldSheet) {
             QuartzForm(quartzPrms: QuartzPrms.newHold, onSubmit: addHoldQuartz )
        }
        .sheet(isPresented: $isShowQuitSheet) {
             QuartzForm(quartzPrms: QuartzPrms.newQuit, onSubmit: addQuitQuartz )
        }
    }
}

extension SummaryScreen{
    var addButton: some View{
        Button{
        }label: {
            SFSymbol.plus
                .font(.system(size: 30))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, Color.accentColor.gradient)
        }
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
        // .environmentObject(QuartzModel())
    }
}

