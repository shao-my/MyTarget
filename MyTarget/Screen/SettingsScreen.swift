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
    
    @AppStorage(.isOpenFaceIdLock) private var isOpenFaceIdLock: Bool = false
   /* @AppStorage(.isUnlocked) private var isLocked: Bool = false
    @StateObject var faceIDModel : FaceIDModel = FaceIDModel()
    @Environment(\.scenePhase) var scenePhase
    */

    var body: some View {
        NavigationView{
            VStack {
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
                            Label("FaceID 解锁", systemImage: .lock)
                        }
                        .toggleStyle(.switch)
                    } 
                    
                    Section("自述") {
                        LabeledContent {
                            Text("V1.0")
                                .font(.subheadline)
                        } label: {
                            Label("版本", systemImage: .box)
                        }
                        
                        LabeledContent {
                            SFSymbol.mail
                                .resizable()
                                .frame(width: 24,height: 24)
                                .foregroundColor(Color.accentColor)
                        } label: {
                            Label("协议", systemImage: .smile)
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
    }
}


struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
