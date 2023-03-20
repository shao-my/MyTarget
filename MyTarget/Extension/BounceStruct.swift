//
//  BounceStruct.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/19.
//

import SwiftUI

struct Bounce: AnimatableModifier {
  let animCount: Int
  var animValue: CGFloat
  var amplitude: CGFloat // 振幅
  var bouncingTimes: Int
  
  init(animCount: Int, amplitude: CGFloat = 10, bouncingTimes: Int = 3) {
    self.animCount = animCount
    self.animValue = CGFloat(animCount)
    self.amplitude = amplitude
    self.bouncingTimes = bouncingTimes
  }
  
  var animatableData: CGFloat {
    get { animValue }
    set { animValue = newValue }
  }
  
  func body(content: Content) -> some View {
    let t = animValue - CGFloat(animCount)
    let offset: CGFloat = -abs(pow(CGFloat(M_E), -t) * sin(t * .pi * CGFloat(bouncingTimes)) * amplitude)
    return content.offset(y: offset)
  }
}

extension View {
  func bounce(animCount: Int,
        amplitude: CGFloat = 10,
        bouncingTimes: Int = 3) -> some View {
    self.modifier(Bounce(animCount: animCount,
               amplitude: amplitude,
               bouncingTimes: bouncingTimes))
  }
}
