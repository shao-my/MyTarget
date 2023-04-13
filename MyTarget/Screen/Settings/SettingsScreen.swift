//
//  SettingsScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
import StoreKit

struct SettingsScreen: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var pomodoroModel: PomodoroModel

    @AppStorage(.isOpenFaceIdLock) private var isOpenFaceIdLock: Bool = false
    @AppStorage(.isShowIsland) private var isShowIsland: Bool = false
     
    @State var isShowSelfRecount: Bool = false
    @AppStorage(.myLocale) private var myLocale: String = "zh_cn" 
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var countNum = 5
    
    @State private var settingPagePresented: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section  {
                        Toggle(isOn: $shouldUseDarkMode){
                            Label("深色模式", systemImage: .moon)
                        }
                        .toggleStyle(.switch)
                        
                        Picker(selection: $myLocale) {
                            Text("中文").tag("zh_cn")
                            Text("英文").tag("en-US")
                        } label: {
                            Label("中英日历", systemImage: .calendar)
                        }
                        
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
                        
                        LabeledContent {
                           NavigationLink {
                                FocusView()
                                        .environmentObject(pomodoroModel)
                            } label: {
                                Text("")
                                    .push(to: .trailing)
                            }
                            .navigationBarTitle("设置")  
                        } label: {
                            Label("专注模式", systemImage: .brain)
                        }
                        
                        /*if #available(iOS 16.1, *) {
                            Toggle(isOn: $isShowIsland){
                                Label("灵动岛", systemImage: .bear)
                            }
                            .toggleStyle(.switch)
                        }*/
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
        .sheet(isPresented: $isShowSelfRecount) {
            SelfRecount()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
            .environmentObject(PomodoroModel())
    }
}
