//
//  TargetWidget.swift
//  TargetWidget
//
//  Created by 邵明易 on 2023/4/10.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {
    var moc = PersistenceController.shared.container.viewContext
    
    
    // 自定义函数，获取 item 的数量
    private func fetchDayBookForDay() -> [DayBook] {
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        requestDayBook.predicate =   NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date()))
        do {
            dayBooks = try moc.fetch(requestDayBook)
        } catch let error {
            print(error.localizedDescription)
        }
        return dayBooks
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let dayBookList: [DayBook] =  fetchDayBookForDay()
        let holdSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
        let quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
        let holdProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
        let quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(),count: dayBookList.count,
                                holdProgress: holdProgress,
                                quitProgress: quitProgress,
                                holdSummaryStr: holdSummaryStr,
                                quitSummaryStr: quitSummaryStr
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let dayBookList: [DayBook] =  fetchDayBookForDay()
        let holdSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
        let quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
        let holdProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
        let quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
        let entry = SimpleEntry(date: Date(), configuration: configuration,count: dayBookList.count,
                                holdProgress: holdProgress,
                                quitProgress: quitProgress,
                                holdSummaryStr: holdSummaryStr,
                                quitSummaryStr: quitSummaryStr
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let dayBookList: [DayBook] =  fetchDayBookForDay()
            
            let holdSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
            let quitSummaryStr = getDayBookSummary(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
            let holdProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "HOLD")
            let quitProgress = getDayBookPercent(dayBooks: dayBookList.reversed(), quartzType: "QUIT")
            
            let entry = SimpleEntry(date: Date(), configuration: configuration,count: dayBookList.count,
                                    holdProgress: holdProgress,
                                    quitProgress: quitProgress,
                                    holdSummaryStr: holdSummaryStr,
                                    quitSummaryStr: quitSummaryStr
            )
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var count: Int = 0
    var holdProgress: Double = 0.0
    var quitProgress: Double = 0.0
    var holdSummaryStr:  String = "00 / 00"
    var quitSummaryStr:  String = "00 / 00"
}

struct TargetWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @State var flipHoldScore  = false
    @State var flipQuitScore  = false
    
    var body: some View {
            HStack {
                if family == .systemMedium {
                    VStack{
                        VStack (spacing: 16){
                            ZStack{
                                Text("")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.bg2)
                                HStack {
                                    Text(entry.holdSummaryStr.prefix(2))
                                        .foregroundColor(.white)
                                        .font(.title.bold())
                                        .frame(width: 50, height: 50)
                                        .roundedRectBackground(radius: 8, fill: Color.accentColor.opacity(0.6))
                                    
                                    Text(entry.holdSummaryStr.suffix(2))
                                        .font(.title.bold())
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity).background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.bg2)
                        }
                        
                        VStack (spacing: 16){
                            ZStack{
                                Text("")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.bg2)
                                HStack {
                                    Text(entry.quitSummaryStr.prefix(2))
                                        .foregroundColor(.white)
                                        .font(.title.bold())
                                        .frame(width: 50, height: 50)
                                        .roundedRectBackground(radius: 8, fill: Color.red.opacity(0.6))
                                    
                                    Text(entry.quitSummaryStr.suffix(2))
                                        .font(.title.bold())
                                        .frame(width: 50, height: 50)
                                }
                            }
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity).background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.bg2)
                        }
                    }
                    .padding(.leading, 15)
                    .padding(.vertical, 20)
                }
                
                GeometryReader { (geometry) in
                    makeCircle(geometry, holdProgress: entry.holdProgress, quitProgress: entry.quitProgress)
                }
                .padding()
                .padding(.trailing, 5)
                .padding(.vertical, 5)
            }
            .widgetBackground(self)
    }
      
    
    func makeCircle(_ geometry: GeometryProxy,holdProgress: Double,quitProgress: Double) -> some View {
        return  ZStack {
            let width = min(geometry.size.width,geometry.size.height)
            
            Circle()
                .stroke(Color.accentColor.opacity(0.3),lineWidth: 30)
            
            RingInnerShape(progress: 1, thickness: 25)
                .fill(Color(.red).opacity(0.3))
            /*   SFSymbol.arrowRight
             .font(.body.bold())
             .imageScale(.large)
             .scaleEffect(scale)
             .animateForever(using: Animation.easeInOut(duration: 1)) { scale = 0.8 }
             */
            
            ZStack {
                ZStack {
                    RingShape(progress: holdProgress, thickness: 25)
                        .fill(Color.accentColor)
                    
                    RingHeaderShape(progress: holdProgress, thickness: 25)
                        .fill(Color.accentColor)
                        .shadow(color: holdProgress >= 1 ? .black.opacity(0.7) : .clear ,radius:  holdProgress >= 1 ? 1.2 : 0)
                    
                    
                    RingHeader1Shape(progress: holdProgress  , thickness: 25)
                        .fill(Color.accentColor)
                }
                
                ZStack {
                    RingInnerShape(progress: quitProgress, thickness: 25)
                        .fill(Color.red)
                    
                    RingInnerHeaderShape(progress: quitProgress, thickness: 25)
                        .fill(Color.red)
                        .shadow(color: quitProgress >= 1 ? .black.opacity(0.7) : .clear ,radius:  quitProgress >= 1 ? 1.2 : 0)
                    
                    RingInnerHeader1Shape(progress: quitProgress  , thickness: 25)
                        .fill(Color.red)
                }
                
                Image(systemName: "arrow.down")
                    .font(.callout.bold())
                    .foregroundColor(Color.black)
                    .frame(width: 25, height: 25)
                    .offset(x: width / 2 - 29)
                    .rotationEffect(.init(degrees: -91))
            }
            
            Image(systemName: "arrow.down")
                .font(.callout.bold())
                .foregroundColor(Color.black)
                .frame(width: 25, height: 25)
                .offset(x: width / 2 )
                .rotationEffect(.init(degrees: -91))
        }
        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        .animation(Animation.easeOut(duration: 1.6),value: holdProgress)
        .animation(Animation.easeOut(duration: 1.6),value: quitProgress)
         
    }
    
    
    struct BiteHalfCircle: Shape {
        func path(in rect: CGRect) -> Path {
            let offset = rect.maxX - 25
            let crect = CGRect(origin: .zero, size: CGSize(width: 25, height: 25)).offsetBy(dx: offset, dy: offset)
            
            var path = Rectangle().path(in: rect)
            path.addPath(Circle().path(in: crect))
            return path
        }
    }
    
    // 内环
    struct RingShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(startAngle - 2 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
            
        }
    }
    
    // 头圈
    struct RingHeaderShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(360 * progress + startAngle - 1 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 头圈
    struct RingHeader1Shape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let ang =  progress <= 0.01 ? 360 * progress + startAngle : 360 * progress + startAngle - 8
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(ang),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 箭头
    struct RingHeaderArrow: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            // path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(startAngle ),endAngle: .degrees(startAngle), clockwise: false)
            
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 10/2, y: -10))
            path.move(to: CGPoint(x: 10/2, y:  -10))
            path.addLine(to: CGPoint(x: 10, y: 0))
            
            
            return path.strokedPath(.init(lineWidth: 2, lineCap: .round))
            
            
        }
    }
    
    
    // 内环
    struct RingInnerShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 40.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0 ), radius: min(rect.width, rect.height) / 2.0 - 29,startAngle: .degrees(startAngle - 2 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 头圈
    struct RingInnerHeaderShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0 - 29,startAngle: .degrees(360 * progress + startAngle - 1 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 头圈
    struct RingInnerHeader1Shape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let ang =  progress <= 0.01 ? 360 * progress + startAngle : 360 * progress + startAngle - 8
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0 - 29,startAngle: .degrees(ang),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
}

struct TargetWidget: Widget {
    let kind: String = "TargetWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TargetWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Target")
        .description("This is my Target widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct TargetWidget_Previews: PreviewProvider {
    static var previews: some View {
        TargetWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *){
            return containerBackground(for: .widget){
                Color.clear
            }
        }else {
            return backgroundView
        }
    }
}
