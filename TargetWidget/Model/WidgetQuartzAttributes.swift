//
//  WidgetDemoAttributes.swift
//  DynamicIslandDemo
//
//  Created by chenhao on 2022/11/14.
//

import ActivityKit

struct WidgetQuartzAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var quartzName: String = ""
        var quartzIcon: String = "def"
        var quartzColor: String = ""
        var remainderText: String = ""
        var totalSeconds: Int = 0 
        var timerStringValue: String = "00:00" 
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
