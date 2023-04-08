//
//  FaceIDModel.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/8.
//

import SwiftUI
import LocalAuthentication

class FaceIDModel: ObservableObject {
    //@Published var isLocked: Bool = false
    @AppStorage(.isUnlocked) private var isLocked: Bool = false

    func authenticate(){
        let context = LAContext()
        var error: NSError?

        // 检查是否可以进行生物特征识别
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 如果可以，执行识别
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // 鉴权完成
                DispatchQueue.main.async {
                    if success {
                       self.isLocked = false
                    } else {
                       self.isLocked = true
                    }
                }
            }
        } else {
            print(" 没有生物特征识别功能权失败")    //
        }
        
        
    }

}
 
 
