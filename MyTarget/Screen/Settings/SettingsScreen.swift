//
//  SettingsScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
import StoreKit
import ActivityKit

struct SettingsScreen: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    
    @AppStorage(.isOpenFaceIdLock) private var isOpenFaceIdLock: Bool = false
    @AppStorage(.isShowIsland) private var isShowIsland: Bool = false
   /* @AppStorage(.isUnlocked) private var isLocked: Bool = false
    @StateObject var faceIDModel : FaceIDModel = FaceIDModel()
    @Environment(\.scenePhase) var scenePhase
    */
    @State var isShowSelfRecount: Bool = false
    
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
       @State private var countNum = 5

    var body: some View {
        NavigationView{
            VStack {
               /* Text("\(countNum)")
                           .onReceive(timer) { input in
                               if countNum > 0{
                                   countNum -= 1
                               } else if countNum == 0{
                                   countNum = 5
                               }
                           }*/
                Form {
                    Section("基本设定") {
                        Toggle(isOn: $shouldUseDarkMode){
                            Label("深色模式", systemImage: .moon)
                        }
                        .toggleStyle(.switch)
                        
                        LabeledContent {
                            Text("暂未开通")
                                .font(.subheadline)
                        } label: {
                            Label("iCloud", systemImage: .icloud)
                        }
                        
                        Toggle(isOn: $isOpenFaceIdLock){
                            Label("FaceID 解锁", systemImage: .faceid)
                        }
                        .toggleStyle(.switch)
                       
                        if #available(iOS 16.1, *) {
                            Toggle(isOn: $isShowIsland){
                                Label("灵动岛", systemImage: .bear)
                            }
                            .toggleStyle(.switch)
                        }
                    } 
                    
                    Section("说明书") {
                        LabeledContent {
                            Text("V1.0")
                                .font(.subheadline)
                        } label: {
                            Label("版本", systemImage: .box)
                        }
                        
                        LabeledContent {
                            Button  {
                               isShowSelfRecount = true
                            } label: {
                                SFSymbol.mail
                                    .resizable()
                                    .frame(width: 24,height: 24)
                            }
                        } label: {
                            Label("自述", systemImage: .smile)
                        }
                        
                        LabeledContent {
                            Button  {
                                requestReview()
                            } label: {
                                SFSymbol.thumbsup
                                    .resizable()
                                    .frame(width: 24,height: 24)
                            }
                        } label: {
                            Label("评价", systemImage: .heart)
                        }
                           
                        LabeledContent {
                            Button  {
                                //requestReview()
                            } label: {
                                SFSymbol.dollar
                                    .resizable()
                                    .frame(width: 24,height: 24)
                            }
                        } label: {
                            Label("打赏", systemImage: .gift)
                        }
                        
                        Text("©️2023 Designed & Developed By Json.")
                            .font(.caption2)
                            .push(to: .center)
                    }
                }
            }
            .background(.bg2)
        }
        .onChange(of: isShowIsland) { newValue in
            if (isShowIsland){
                startActivity()
            }else {
                endActivity()
            }
        }
        .sheet(isPresented: $isShowSelfRecount) {
            SelfRecount()
        }
       
    }
    
    /// 开启灵动岛显示功能
    func startActivity(){
        Task{
            let attributes = WidgetDemoAttributes(name:"我是名字")
            let initialContentState = WidgetDemoAttributes.ContentState(value: 100,name: "Json")
            do {
                if #available(iOS 16.1, *) {
                    _ = try Activity<WidgetDemoAttributes>.request(
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
            let updatedStatus = WidgetDemoAttributes.ContentState(value: 2000,name: "Json")
            if #available(iOS 16.1, *) {
                for activity in Activity<WidgetDemoAttributes>.activities{
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
                for activity in Activity<WidgetDemoAttributes>.activities{
                    await activity.end(dismissalPolicy: .immediate)
                    print("已关闭灵动岛显示")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
