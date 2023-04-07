//
//  SettingsScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
import StoreKit
import LocalAuthentication

struct SettingsScreen: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
     
    @AppStorage(.isOpenFaceIdLock) private var isOpenFaceIdLock: Bool = false
    @State private var isGoOpenAuth: Bool = false

    
    var body: some View {
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
                          /*  Button  {
                                requestReview()
                            } label: {
                                Text("查看")
                                    .font(.callout)
                            }
                            .padding(4)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.accentColor))
                           */
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
                        
                        
                        Text("©️2023 Designed & Developed By Json.")
                            .font(.caption2)
                            .push(to: .center)
                    }
                }
            }
            .background(.bg2)
            .onChange(of: isOpenFaceIdLock, perform: { newValue in
                if isOpenFaceIdLock {
                    authenticate()
                }
            })
            .alert("", isPresented: $isGoOpenAuth) {
                Button(role: .cancel) {
                    self.isGoOpenAuth = false
                    self.isOpenFaceIdLock = false
                } label: {
                    Text("取消")
                }
                Button() {
                   // 前往设置页面进行授权
                   guard let url = URL(string: UIApplication.openSettingsURLString)  else  {
                       return
                   }
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                   } else {
                       UIApplication.shared.openURL(url)
                   }
                } label: {
                    Text("去开启")
                }
            } message: {
                Text("开启面容 ID 权限才能够使用解锁哦")
            }
            
    }
    
    // 先检测是否开启面容id授权
    func authenticate() {
        print("here >>")
        let context = LAContext()
        var error: NSError?
        // 检查是否可以进行生物特征识别
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.isGoOpenAuth = false
        } else {
            // 没有生物指纹识别功能
            if (error?.code == -6) {
                self.isGoOpenAuth = true
                print("没有生物指纹识别功能")
            }
        }
        print(isGoOpenAuth)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
