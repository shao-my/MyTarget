//
//  FaceIDView.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/8.
//

import SwiftUI
import LocalAuthentication

struct FaceIDView: View {
    @StateObject var faceIDModel : FaceIDModel = FaceIDModel()
    
    var body: some View {
        VStack {
            Image(systemName: "faceid")
                .foregroundColor(Color.accentColor)
                .font(.system(size: 64))
                .padding()
            
            Button(action: {
                // 如果用户不小心取消了解锁，需要提供一个点击重新解锁的方式：当用户点击时，调用面容 ID 解锁
                faceIDModel.authenticate()
            }, label: {
                VStack {
                    Text("解锁 Face ID")
                        .font(.callout.bold())
                        .foregroundColor(.white)
                }
            })
            .padding()
            .roundedRectBackground(radius: 8, fill: Color.accentColor)
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bg2)
        .zIndex(999)
        .onAppear {
            faceIDModel.authenticate()
        }
    }
} 

struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        FaceIDView()
    }
}
