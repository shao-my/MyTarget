//
//  FlipIconByTimes.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/20.
//

import SwiftUI

struct FlipIconByTimes: View {
    
    @State var dayBook: DayBook
    @State var flipped: Bool
    @State var bookSize = 80.0
    @State var total: Int
    @State var times: Int
    
    var body: some View {
        let flipDegrees = flipped ? 180.0 : 0
        
        
        /*VStack {
         ZStack {
         Image(systemName:  dayBook.quartzIcon ?? "def")
         .resizable()
         .padding()
         .frame(width: bookSize, height: bookSize)
         .bold()
         .foregroundColor(.white)
         .roundedRectBackground(radius: bookSize, fill:Color(SYSColor(rawValue: dayBook.quartzColor ?? "gray")!.create))
         .flipHRotate(flipDegrees).opacity(flipped ? 0.0 : 1.0)
         
         Image(systemName: "checkmark")
         .resizable()
         .padding()
         .frame(width: bookSize, height: bookSize)
         .bold()
         .foregroundColor(.white)
         .placedOnCard(Color.green,size: bookSize)
         .flipHRotate(-180 + flipDegrees )
         .opacity(flipped ? 1.0 : 0.0)
         
         }
         .padding(.vertical)
         .animation(.easeInOut(duration: 0.8), value: flipped)
         .onTapGesture {
         self.flipped.toggle()
         }
         }
         */
        
        ZStack() {
            ZStack{
                Circle()
                    .frame(width: bookSize, height: bookSize)
                    .foregroundColor(Color(SYSColor(rawValue: dayBook.quartzColor ?? "gray")!.create)).mask(BiteCircle().fill(style: .init(eoFill: true)))
                
                
                
                Image(systemName:  dayBook.quartzIcon ?? "def")
                    .resizable()
                    .padding()
                    .frame(width: bookSize, height: bookSize)
                    .bold()
                    .foregroundColor(.white) 
                
              //  if (times < total ){
                    Text("\(times)")
                        .frame(width: 28, height: 28)
                        .bold()
                        .foregroundColor(.white)
                        .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                        .flipSmallRotate( flipDegrees,x: 0,y: -1).opacity(flipped ? 0.0 : 1.0)
                        .offset(x: 25, y: 25)
                        .opacity(times < total ? 1.0 : 0.0)
               // }else{
                    Image(systemName: "checkmark")
                        .padding()
                        .frame(width: 28, height: 28)
                        .bold()
                        .foregroundColor(.white)
                        .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                        .flipSmallRotate(flipDegrees,x: 0,y: -1).opacity(flipped ? 0.0 : 1.0)
                        .offset(x: 25, y: 25)
                        .opacity(times < total ? 0.0 : 1.0)
               // }
            }
            
           // if (times < total ){
                Text("\(times)")
                    .frame(width: 28, height: 28)
                    .bold()
                    .foregroundColor(.white)
                    .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                    .flipSmallRotate(-180 + flipDegrees,x: 0,y: -1).opacity(flipped ? 1.0 : 0.0)
                    .offset(x: 25, y: 25)
                    .opacity(times < total ? 1.0 : 0.0)
           // }else{
                Image(systemName: "checkmark")
                    .padding()
                    .frame(width: 28, height: 28)
                    .bold()
                    .foregroundColor(.white)
                    .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                    .flipSmallRotate(-180 + flipDegrees,x: 0,y: -1).opacity(flipped ? 1.0 : 0.0)
                    .offset(x: 25, y: 25)
                    .opacity(times < total ? 0.0 : 1.0)
            //}
            
            
        }
        .animation(.easeInOut(duration: 0.8), value: flipped)
        .onTapGesture { 
            self.flipped.toggle()
            //重置次数
            if (times < total ) {
                times = times + 1
            } else {
                times = 0
            }
        }
    }
}


struct BiteCircle: Shape {
    func path(in rect: CGRect) -> Path {
        let offset = rect.maxX - 32
        let crect = CGRect(origin: .zero, size: CGSize(width: 32, height: 32)).offsetBy(dx: offset, dy: offset)
        
        var path = Rectangle().path(in: rect)
        path.addPath(Circle().path(in: crect))
        return path
    }
}


struct BiteCard: Shape {
    func path(in rect: CGRect) -> Path {
        let offset = CGFloat(-25)
        let crect = CGRect(origin: .zero, size: CGSize(width: 32, height: 32)).offsetBy(dx: offset, dy: offset)
        
        var path = Rectangle().path(in: rect)
        path.addPath(Circle().path(in: crect))
        return path
    }
}
