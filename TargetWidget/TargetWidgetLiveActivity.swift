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
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetDemoAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("center value：\(context.state.value)")
                Text("center value：\(context.state.name)")
            }
            .onAppear {
                print(context)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("center value：\(context.state.value)")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct TargetWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = WidgetDemoAttributes(name: "Me")
    static let contentState = WidgetDemoAttributes.ContentState(value: 3,name: "Json")

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
