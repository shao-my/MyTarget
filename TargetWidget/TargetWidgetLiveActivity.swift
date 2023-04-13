//
//  TargetWidgetLiveActivity.swift
//  TargetWidget
//
//  Created by 邵明易 on 2023/4/10.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct TargetWidgetLiveActivity: Widget {
    @State var timeCount: String = ""
    @State var isPaused: Bool = false
    let themeColor: Color = Color(red: 220 / 255, green: 160 / 255, blue: 90 / 255)
    
    var body: some WidgetConfiguration {
        
        
        ActivityConfiguration(for: WidgetQuartzAttributes.self) { context in
            // Lock screen/banner UI goes here
            HStack(spacing: 15){
               /* Button {
                    isPaused.toggle()
                } label: {
                    Image(systemName: isPaused ?  "play" : "pause")
                        .font(.title3.bold())
                        .foregroundColor(themeColor)
                        .padding()
                        .background {
                            Circle()
                                .fill(themeColor.opacity(0.3))
                        }
                      
                }
                
                Button {
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                        }
                }*/
                
                Image(systemName: context.state.quartzIcon)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background {
                        Circle()
                            .fill(Color(SYSColor(rawValue:  context.state.quartzColor )!.create).opacity(0.3))
                    }
                
                Text("\(context.state.quartzName)")
                        .multilineTextAlignment(.trailing)
                        .font(.title2.bold())
                        .foregroundColor(themeColor)
                
                Spacer() 
              
                
                let future =  Calendar.current.date(byAdding: .second, value: context.state.totalSeconds , to:  Date())!
                let date =  Date.now...future
                Text(timerInterval: date, countsDown: true)
                    .multilineTextAlignment(.trailing)
                    .monospacedDigit()
                    .font(.title2.bold())
                    .foregroundColor(themeColor)
            }
            .padding()
            .onAppear {
                //print(context)
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack {
                        Image(systemName: context.state.quartzIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text(context.state.quartzName)
                            .foregroundColor(.indigo)
                            .font(.title2)
                        
                    }
                    .push(to: .center)
                }
                DynamicIslandExpandedRegion(.center) {
                    
                }
                DynamicIslandExpandedRegion(.trailing) {
                    let future =  Calendar.current.date(byAdding: .second, value: context.state.totalSeconds , to:  Date())!
                    let date =  Date.now...future
                    VStack {
                        Image(systemName: "timer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text(timerInterval: date, countsDown: true)
                            .foregroundColor(.indigo)
                            .font(.title2)
                        
                    }
                    .push(to: .center)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button {
                        // Deep link into your app.
                    } label: {
                        Text("\(context.state.remainderText)")
                    }
                    .foregroundColor(.indigo)
                    
                }
            } compactLeading: {
                Image(systemName: context.state.quartzIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .offset(x: -4)
                    .foregroundColor(.indigo)
            } compactTrailing: {
                let future =  Calendar.current.date(byAdding: .second, value: context.state.totalSeconds , to:  Date())!
                let date =  Date.now...future
                Text(timerInterval: date, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .font(.caption2)
            } minimal: {
                let future =  Calendar.current.date(byAdding: .second, value: context.state.totalSeconds , to:  Date())!
                let date =  Date.now...future
                Image(systemName: context.state.quartzIcon)
                Text(timerInterval: date, countsDown: true)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                    .font(.caption2)
            }
            //.widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.cyan)
        }
    }
    
    
}

struct TargetWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = WidgetQuartzAttributes(name: "Quartz")
    static let contentState = WidgetQuartzAttributes.ContentState()
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
