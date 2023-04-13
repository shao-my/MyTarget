//
//  ActivityAction+.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/12.
//

import SwiftUI
import ActivityKit
 
    /// 开启灵动岛显示功能
    func startActivity(){
        Task{
            let attributes = WidgetQuartzAttributes(name:"我是名字")
            let initialContentState = WidgetQuartzAttributes.ContentState()
            do {
                if #available(iOS 16.1, *) {
                    _ = try Activity<WidgetQuartzAttributes>.request(
                        attributes: attributes,
                        contentState: initialContentState,
                        pushType: nil)
                } else {
                    // Fallback on earlier versions
                }
                
            } catch (let error) {
                print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
            }
        }
    }
    
    /// 更新灵动岛显示
    func updateActivity(){
        Task{
            let updatedStatus = WidgetQuartzAttributes.ContentState()
            if #available(iOS 16.1, *) {
                for activity in Activity<WidgetQuartzAttributes>.activities{
                    await activity.update(using: updatedStatus)
                    print("已更新灵动岛显示 Value值已更新 请展开灵动岛查看")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /// 结束灵动岛显示
    func endActivity(){
        Task{
            if #available(iOS 16.1, *) {
                for activity in Activity<WidgetQuartzAttributes>.activities{
                    await activity.end(dismissalPolicy: .immediate)
                    print("已关闭灵动岛显示")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    } 

 
