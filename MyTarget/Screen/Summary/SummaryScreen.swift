//
//  SummaryView.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
import CoreData 

struct SummaryScreen: View {
    //@Environment(\.managedObjectContext) private var viewContext
    @StateObject public var coreDataModel = CoreDataModel()
    
    /*@FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \Quartz.rid, ascending: true)], predicate : NSPredicate(format: "quartzType = %@", "HOLD"),
     animation: .default)
     private var quartzsHold: FetchedResults<Quartz>
     
     @FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \Quartz.rid, ascending: true)], predicate : NSPredicate(format: "quartzType = %@", "HOLD"),
     animation: .default)
     private var quartzsQuit: FetchedResults<Quartz>*/
    
    // @State private var holdSummary: String =
    // @State private var quitSummary: String = "0 / 0"
    @State private var sheet: Sheet?
    //@State private var quartzItems: [DayBook] = []
    
    private var isAddHoldQuartz: Bool  { coreDataModel.dayBooks.count == 0 }
    
    /*@FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.id, ascending: true)],
     animation: .default)
     private var books: FetchedResults<DayBook>
     
     @FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \Quartz.id, ascending: true)],
     animation: .default)
     private var quartzs: FetchedResults<Quartz>*/
    
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
    @State var holdSummaryStr: String = "0 / 0"
    @State var quitSummaryStr: String = "0 / 0"
    
    
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
                                
                                FlipScore(frontStr: $holdSummaryStr, backStr: $holdSummaryStr, flipped: $flipHoldScore, frontDegrees: $holdFrontDegrees, backDegrees: $holdBackDegrees, scoreColor: Color.accentColor)
                                
                                /*Text(holdSummaryStr)
                                 .font(.title.bold())
                                 .foregroundColor(.green)
                                 .animation(.mySpring, value: holdSummaryStr)*/
                            }
                            .padding()
                            .frame(maxWidth: .infinity).background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.bg2)
                            }
                            
                            
                            VStack (spacing: 16){
                                Text("戒，警也。")
                                    .font(.subheadline)
                                
                                FlipScore(frontStr: $quitSummaryStr, backStr: $quitSummaryStr, flipped: $flipQuitScore, frontDegrees: $quitFrontDegrees, backDegrees: $quitBackDegrees, scoreColor: Color.red)
                                
                               /* Text(getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT"))
                                    .font(.title.bold())
                                    .foregroundColor(.red)*/
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
                        .frame(maxWidth: .infinity,maxHeight: .infinity).background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.bg2)
                        }
                    }
                    .onAppear {
                        holdSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                        quitSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                        holdProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                        quitProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                    }
                    
                    
                    ZStack {
                        Text("恒之")
                            .font(.title3.bold())
                            .push(to: .leading)
                        
                        /*HStack{
                         Spacer()
                         addButton
                         .opacity(isAddHoldQuartz ? 0 : 1)
                         .scaleEffect(isAddHoldQuartz ? 0 : 1)
                         .animation(.easeInOut, value: isAddHoldQuartz)
                         }*/
                    }
                    .padding(.top)
                    
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(coreDataModel.dayBooks) { book in
                                    /*   var flipped = false
                                     ZStack {
                                     if book.quartzType == "HOLD" {
                                     Image(systemName:  book.quartzIcon ?? "def")
                                     .resizable()
                                     .padding()
                                     .frame(width: bookSize, height: bookSize)
                                     .bold()
                                     .foregroundColor(.white)
                                     .roundedRectBackground(radius: bookSize, fill:Color(SYSColor(rawValue: book.quartzColor ?? "gray")!.create))
                                     .flipRotate(flipped ? 180.0 : 0).opacity(flipped ? 0.0 : 1.0)
                                     
                                     Image(systemName: "checkmark.circle").resizable().placedOnCard(Color.green).flipRotate(     flipped ?  0 : -180  ).opacity(flipped ? 1.0 : 0.0)
                                     
                                     }
                                     }
                                     .animation(.easeInOut(duration: 0.8), value: flipped)
                                     .onTapGesture {
                                     flipped.toggle()
                                     }*/
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
                                                        
                                                        holdSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                                                        holdProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                                                        coreDataModel.saveDayBook()
                                                        
                                                    }
                                                )
                                        }
                                        else{
                                            FlipIcon(dayBook: book,flipped: book.isCompleted)
                                                .simultaneousGesture(
                                                    TapGesture().onEnded{
                                                        book.isCompleted.toggle()
                                                        coreDataModel.saveDayBook()
                                                        holdSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                                                        holdProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "HOLD")
                                                        flipHoldScore.toggle()
                                                        holdFrontDegrees = holdFrontDegrees + 180
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
                                        sheet = .newQuartzHold() {
                                            coreDataModel.addQuartz(quartzPrms: $0)
                                        }
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
                                ForEach(coreDataModel.dayBooks) { book in
                                    /*if book.quartzType == "QUIT" {
                                     Image(systemName:  book.quartzIcon ?? "def")
                                     .resizable()
                                     .padding()
                                     .frame(width: bookSize, height: bookSize)
                                     .bold()
                                     .foregroundColor(.white)
                                     .roundedRectBackground(radius: bookSize, fill:Color(SYSColor(rawValue: book.quartzColor ?? "gray")!.create))
                                     }*/
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
                                                        quitSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                        quitProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                        coreDataModel.saveDayBook()
                                                        
                                                    }
                                                )
                                            
                                        }else{
                                            FlipIcon(dayBook: book,flipped: book.isCompleted)
                                                .simultaneousGesture(
                                                    TapGesture().onEnded{
                                                        book.isCompleted.toggle()
                                                        coreDataModel.saveDayBook()
                                                        quitSummaryStr = getDayBookSummary(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                        quitProgress = getDayBookPercent(dayBooks: coreDataModel.dayBooks, quartzType: "QUIT")
                                                        flipQuitScore.toggle()
                                                        quitFrontDegrees = quitFrontDegrees + 180
                                                    }
                                                )
                                        }
                                    }
                                }
                                
                                Text("+")
                                    .font(.body.bold())
                                    .frame(width: bookSize, height: bookSize)
                                //.padding()
                                //.lineLimit(1)
                                    .roundedRectBackground(radius: bookSize,fill: .bg2)
                                    .onTapGesture {
                                        sheet = .newQuartzQuit() {
                                            coreDataModel.addQuartz(quartzPrms: $0)
                                        }
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
                
            }
            .navigationBarTitle(Text("概要"), displayMode: .automatic)
            .navigationBarItems(
                leading:
                    Text(getMonthDayWeek())
                    .font(.subheadline.bold())
                    .foregroundColor(Color(.systemGray))
            )
            
        }
        
        .sheet(item: $sheet){ $0 }
        
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
        // .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

