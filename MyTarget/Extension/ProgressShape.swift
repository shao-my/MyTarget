//
//  PorgressShape.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/19.
//

import SwiftUI

extension SummaryScreen {
    
    func makeCircle(_ geometry: GeometryProxy,holdProgress: Double,quitProgress: Double) -> some View {
        return   ZStack {
            Circle()
                .stroke(Color.accentColor.opacity(0.1),lineWidth: 30)
            
            RingInnerShape(progress: 1, thickness: 25)
                .fill(Color(.red).opacity(0.1))
            
            SFSymbol.arrowRight
                .font(.body.bold())
                .imageScale(.large)
                .scaleEffect(scale)
                .animateForever(using: Animation.easeInOut(duration: 1)) { scale = 0.8 }
            
            ZStack {
                ZStack {
                    RingShape(progress: holdProgress, thickness: 25)
                        .fill(Color.accentColor)
                    
                    RingHeaderShape(progress: holdProgress, thickness: 25)
                        .fill(Color.accentColor)
                        .shadow(color: holdProgress >= 1 ? .black.opacity(0.7) : .clear ,radius:  holdProgress >= 1 ? 1.2 : 0)
                    
                    
                    RingHeader1Shape(progress: holdProgress  , thickness: 25)
                        .fill(Color.accentColor)
                }
                
                ZStack {
                    RingInnerShape(progress: quitProgress, thickness: 25)
                        .fill(Color.red)
                    
                    RingInnerHeaderShape(progress: quitProgress, thickness: 25)
                        .fill(Color.red)
                        .shadow(color: quitProgress >= 1 ? .black.opacity(0.7) : .clear ,radius:  quitProgress >= 1 ? 1.2 : 0)
                    
                    RingInnerHeader1Shape(progress: quitProgress  , thickness: 25)
                        .fill(Color.red)
                }
            }
        }
        .padding()
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        .animation(Animation.easeOut(duration: 1.6),value: holdProgress)
        .animation(Animation.easeOut(duration: 1.6),value: quitProgress)
    }
    
    
    
    // 内环
    struct RingShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(startAngle - 2 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
            
        }
    }
    
    // 头圈
    struct RingHeaderShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(360 * progress + startAngle - 1 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 头圈
    struct RingHeader1Shape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let ang =  progress <= 0.01 ? 360 * progress + startAngle : 360 * progress + startAngle - 8
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(ang),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 箭头
    struct RingHeaderArrow: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            // path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0,startAngle: .degrees(startAngle ),endAngle: .degrees(startAngle), clockwise: false)
            
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 10/2, y: -10))
            path.move(to: CGPoint(x: 10/2, y:  -10))
            path.addLine(to: CGPoint(x: 10, y: 0))
            
            
            return path.strokedPath(.init(lineWidth: 2, lineCap: .round))
            
            
        }
    }
    
    
    // 内环
    struct RingInnerShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 40.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0 ), radius: min(rect.width, rect.height) / 2.0 - 29,startAngle: .degrees(startAngle - 2 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 头圈
    struct RingInnerHeaderShape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0 - 29,startAngle: .degrees(360 * progress + startAngle - 1 ),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
    
    // 头圈
    struct RingInnerHeader1Shape: Shape {
        var progress: Double = 0.0
        var thickness: CGFloat = 30.0
        var startAngle: Double = -90.0
        var animatableData: Double {
            get { progress }
            set { progress = newValue }
        }
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let ang =  progress <= 0.01 ? 360 * progress + startAngle : 360 * progress + startAngle - 8
            path.addArc(center: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), radius: min(rect.width, rect.height) / 2.0 - 29,startAngle: .degrees(ang),endAngle: .degrees(360 * progress + startAngle), clockwise: false)
            return path.strokedPath(.init(lineWidth: thickness, lineCap: .round))
            
        }
    }
}
