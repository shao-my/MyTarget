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
    
    @State var scoreAnimationRange: [Int] = [0,0]
    @Binding var scoreValue: Int
    
    @State var totalAnimationRange: [Int] = [0,0]
    @Binding var totalValue: Int
    
    var body: some View {
        
        VStack {
            
            ZStack() {
                HStack {
                    ZStack{
                        HStack(spacing: 0) {
                            ForEach(0..<scoreAnimationRange.count, id: \.self){ index in
                                Text("8")
                                    .font(.largeTitle.bold())
                                    .opacity(0)
                                    .overlay {
                                        GeometryReader{ proxy in
                                            let size = proxy.size
                                            VStack(spacing: 0) {
                                                ForEach(0...9, id: \.self){ number in
                                                    Text("\(number)")
                                                        .font(.largeTitle.bold())
                                                        .frame(width: size.width, height: size.height, alignment: .center)
                                                }
                                            }  .offset(y: -CGFloat(scoreAnimationRange[index]) * size.height)
                                        }
                                        .clipped()
                                    }
                            }
                        } .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .roundedRectBackground(radius: 8, fill: scoreColor.opacity(0.6))
                            .flipVRotate(frontDegrees).opacity(flipped ? 0.0 : 1.0)
                            .onAppear {
                                scoreAnimationRange = Array(repeating: 0, count: (scoreValue < 10 ? "0\(scoreValue)" : "\(scoreValue)").count)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.06){
                                    updateScore(value: scoreValue)
                                }
                            }
                            .onChange(of: scoreValue) { newValue in
                                let extra = (scoreValue < 10 ? "0\(scoreValue)" : "\(scoreValue)").count - scoreAnimationRange.count
                                if extra > 0 {
                                    for _ in 0..<extra {
                                        withAnimation(.easeIn(duration: 0.1)){
                                            scoreAnimationRange.append(0)
                                        }
                                    }
                                }else {
                                    for _ in 0..<(-extra) {
                                        withAnimation(.easeIn(duration: 0.1)){
                                            scoreAnimationRange.removeLast()
                                        }
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                                    updateScore(value: newValue)
                                }
                            }
                        
                        ZStack {
                            Text(frontStr.prefix(2))
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .roundedRectBackground(radius: 8, fill: scoreColor.opacity(0.6))
                                .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                        }
                        .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(0..<totalAnimationRange.count, id: \.self){ index in
                            Text("8")
                                .font(.largeTitle.bold())
                                .opacity(0)
                                .overlay {
                                    GeometryReader{ proxy in
                                        let size = proxy.size
                                        VStack(spacing: 0) {
                                            ForEach(0...9, id: \.self){ number in
                                                Text("\(number)")
                                                    .font(.largeTitle.bold())
                                                    .frame(width: size.width, height: size.height, alignment: .center)
                                            }
                                        }  .offset(y: -CGFloat(totalAnimationRange[index]) * size.height)
                                    }
                                    .clipped()
                                }
                        }
                    }
                    .onAppear {
                        totalAnimationRange = Array(repeating: 0, count: (totalValue < 10 ? "0\(totalValue)" : "\(totalValue)").count)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06){
                            updateText(value: totalValue)
                        }
                    }
                    .onChange(of: totalValue) { newValue in
                        let extra = (totalValue < 10 ? "0\(totalValue)" : "\(totalValue)").count - totalAnimationRange.count
                        if extra > 0 {
                            for _ in 0..<extra {
                                withAnimation(.easeIn(duration: 0.1)){
                                    totalAnimationRange.append(0)
                                }
                            }
                        }else {
                            for _ in 0..<(-extra) {
                                withAnimation(.easeIn(duration: 0.1)){
                                    totalAnimationRange.removeLast()
                                }
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05){
                            updateText(value: newValue)
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.8), value: flipped)
        }
        
    }
    
    func updateText(value: Int) {
        let StringValue =  (totalValue < 10 ? "0\(totalValue)" : "\(totalValue)")
        for(index,value) in zip(0..<StringValue.count, StringValue){
            var fraction = Double(index) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction,blendDuration: 1 + fraction)){
                totalAnimationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
    
    func updateScore(value: Int) {
        let StringValue =  (scoreValue < 10 ? "0\(scoreValue)" : "\(scoreValue)")
        for(index,value) in zip(0..<StringValue.count, StringValue){
            var fraction = Double(index) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction,blendDuration: 1 + fraction)){
                scoreAnimationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
}

