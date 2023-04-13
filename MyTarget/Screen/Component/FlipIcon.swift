//
//  FlipIcon.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/19.
//

import SwiftUI



struct FlipIcon: View {
    @StateObject var dayBook: DayBook
    @State var flipped: Bool
    @State var bookSize = 80.0
    
    var body: some View {
        let flipDegrees = flipped ? 180.0 : 0
        
        ZStack() {
            ZStack{
                if flipped {
                    Circle()
                        .frame(width: bookSize, height: bookSize)
                        .foregroundColor(Color(SYSColor(rawValue: dayBook.quartzColor ?? "gray")!.create)).mask(BiteCircle().fill(style: .init(eoFill: true)))
                }else{
                    Circle()
                        .frame(width: bookSize, height: bookSize)
                        .foregroundColor(Color(SYSColor(rawValue: dayBook.quartzColor ?? "gray")!.create))
                }
                Image(systemName:  dayBook.quartzIcon ?? "def")
                    .resizable()
                    .padding()
                    .frame(width: bookSize, height: bookSize)
                    .bold()
                    .foregroundColor(.white)
                    .zIndex(99)
            } 
            
            Image(systemName: "checkmark")
                .padding()
                .frame(width: 28, height: 28)
                .bold()
                .foregroundColor(.white)
                .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                .flipSmallRotate(-180 + flipDegrees,x: 0,y: -1).opacity(flipped ? 1.0 : 0.0)
                .offset(x: 25, y: 25)
        }
        .animation(.easeInOut(duration: 0.8), value: flipped)
        .onTapGesture { self.flipped.toggle() }
        .onChange(of: dayBook) { newValue in
         
        }
        .onAppear {
            if(dayBook.isCompleted){
                flipped = true
            }
        }
    }
}


