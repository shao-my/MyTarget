//
//  Animation+.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/15.
//

import SwiftUI

extension Animation {
    static let mySpring = Animation.spring(dampingFraction: 0.55)
    static let myEase = Animation.easeInOut(duration: 0.6)
}


// Create an immediate animation.
extension View {
    func animate(using animation: Animation = Animation.easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

// Create an immediate, looping animation
extension View {
    func animateForever(using animation: Animation = Animation.easeInOut(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}



extension View {
    func flipHRotate(_ degrees : Double) -> some View {
        return rotation3DEffect(Angle(degrees: degrees), axis: (x: 0, y: -1.0, z: 0.0))
    }
     
    func flipVRotate(_ degrees : Double) -> some View {
        return rotation3DEffect(Angle(degrees: degrees), axis: (x: 1.0, y: 0.0, z: 0.0))
    }
    
    func flipSmallRotate(_ degrees : Double,x: Double,y: Double) -> some View {
        return rotation3DEffect(Angle(degrees: degrees), axis: (x: x, y: y, z: 0.0))
    }
    
    func placedOnCard(_ color: Color,size: CGFloat) -> some View {
        return padding(5).frame(width: size, height: size, alignment: .center).roundedRectBackground(radius: 100,fill: color)
    }
} 
