//
//  FlipScore.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/20.
//

import SwiftUI

struct FlipScore: View {
    @Binding var frontStr: String
    @Binding var backStr: String
    @Binding var flipped: Bool
    @State var bookSize = 80.0
    
    @Binding var frontDegrees: Double
    @Binding var backDegrees: Double 
    
    @State var scoreColor: Color
    
    var body: some View {
            VStack {
               /* ZStack() {
                    Text(frontStr)
                        .placedOnCard(Color.accentColor.opacity(0.6),size: 80)
                        .flipVRotate(frontDegrees)
                        .opacity(flipped ? 0.0 : 1.0)
                    
                    ZStack {
                        Text(backStr)
                            .placedOnCard(Color.accentColor.opacity(0.6),size: 80)
                            .flipVRotate(backDegrees)
                            .opacity(flipped ? 1.0 : 0.0)
                        
                    }
                    .flipVRotate(backDegrees)
                    .opacity(flipped ? 1.0 : 0.0)
                }
                .animation(.easeInOut(duration: 0.8), value: flipped)
                */
                
                ZStack() {
                    HStack {
                        ZStack{
                            Text(frontStr.prefix(1))
                                .font(.largeTitle.bold())
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                                .roundedRectBackground(radius: 8, fill: scoreColor.opacity(0.6))
                                .flipVRotate(frontDegrees).opacity(flipped ? 0.0 : 1.0)
                            
                            ZStack {
                                Text(frontStr.prefix(1))
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80)
                                    .roundedRectBackground(radius: 8, fill: scoreColor.opacity(0.6))
                                    .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                            }
                            .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                        }
                        
                        Text(frontStr.suffix(1))
                            .font(.largeTitle.bold())
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .roundedRectBackground(radius: 8, fill: .secondary)
                    }
                    
                }
                .animation(.easeInOut(duration: 0.8), value: flipped)
            }
        
    }
}

