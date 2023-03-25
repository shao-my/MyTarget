//
//  FlipText.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/21.
//

import SwiftUI

struct FlipText: View {
    @State var flipped: Bool
    @State var bookSize = 80.0
    
    var body: some View {
        let flipDegrees = flipped ? 180.0 : 0
         
        ZStack() {
            ZStack{
             
                Text("")
                        .padding()
                        .frame(width: 28, height: 28)
                        .bold()
                        .foregroundColor(Color(.clear))
                        .roundedRectBackground(radius: 100, fill: Color(.clear))
                        .border(.blue)
                         
            }
                
            Text("")
                .padding()
                .frame(width: 28, height: 28)
                .bold()
                .foregroundColor(.white)
                .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                .flipSmallRotate(-180 + flipDegrees,x: 0,y: -1).opacity(flipped ? 1.0 : 0.0)
        }
        .animation(.easeInOut(duration: 0.8), value: flipped)
        .onTapGesture { self.flipped.toggle() }
    }
}
 
