//
//  ManageScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

struct ManageScreen: View {
    /*@FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \DayBook.id, ascending: true)],
     animation: .default)
     private var books: FetchedResults<DayBook>*/
    
    @State var flipped = false
    @State var frontStr = "0 / 2"
    @State var backStr = "1 / 2"
    @State var total = 3
    @State var times = 0
    
    @State var frontDegrees = 0.0
    @State var backDegrees = -180.0
    @State var animation = 0.0
    
    var body: some View {
        let flipDegrees = flipped ? 180.0 : 0
        
        
        
        ScrollView {
            Text(getStringForYYYYMMDD(dateTime: Date()))
            
            Text(getStringForHHmm(dateTime: Date()))
            
            ZStack {
                Color.blue.edgesIgnoringSafeArea(.all)
                Image("juejin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 5)
                    )
                    .shadow(radius: 20)
                    .rotation3DEffect(.degrees(animation), axis: (x: 0, y: 1, z: 0.2))
                    .onTapGesture {
                        withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                            self.animation += 360
                        }
                    }
            }
            
            ZStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color.blue)
                    .mask(BiteCircle().fill(style: .init(eoFill: true)))
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
                
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.blue)
                    .offset(x: 25, y: 25)
            }
            
            
            
            VStack{
                Spacer()
                
                ZStack() {
                    ZStack{
                        
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.blue)  .mask(BiteCircle().fill(style: .init(eoFill: true)))
                        
                        Image(systemName:  .def)
                            .resizable()
                            .padding()
                            .frame(width: 60, height: 60)
                            .bold()
                            .foregroundColor(.white)
                            .zIndex(99)
                        
                        if (times < total ){
                            Text("\(times)")
                                .frame(width: 28, height: 28)
                                .bold()
                                .foregroundColor(.white)
                                .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                                .flipSmallRotate(flipDegrees,x: 0,y: -1).opacity(flipped ? 0 : 1.0)
                                .offset(x: 25, y: 25)
                        }else{
                            Image(systemName: "checkmark")
                                .padding()
                                .frame(width: 28, height: 28)
                                .bold()
                                .foregroundColor(.white)
                                .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                                .flipSmallRotate(flipDegrees,x: 0,y: -1).opacity(flipped ? 0.0 : 1.0)
                                .offset(x: 25, y: 25)
                        }
                        
                        
                    }
                    if (times < total ){
                        Text("\(times)")
                            .frame(width: 28, height: 28)
                            .bold()
                            .foregroundColor(.white)
                            .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                            .flipSmallRotate(-180 + flipDegrees,x: 0,y: -1).opacity(flipped ? 1.0 : 0.0)
                            .offset(x: 25, y: 25)
                    }else{
                        Image(systemName: "checkmark")
                            .padding()
                            .frame(width: 28, height: 28)
                            .bold()
                            .foregroundColor(.white)
                            .roundedRectBackground(radius: 100, fill: Color(.systemGreen))
                            .flipSmallRotate(-180 + flipDegrees,x: 0,y: -1).opacity(flipped ? 1.0 : 0.0)
                            .offset(x: 25, y: 25)
                    }
                    
                }
                .animation(.easeInOut(duration: 0.8), value: flipped)
                .onTapGesture {
                    self.flipped.toggle()
                    times = times + 1
                }
                Spacer()
                
                ZStack() {
                    Text(frontStr).placedOnCard(Color.green,size: 80).flipVRotate(frontDegrees).opacity(flipped ? 0.0 : 1.0)
                    
                    ZStack {
                        
                        Text(backStr).placedOnCard(Color.bg2,size: 80)
                            .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                    }
                    .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                    
                }
                .animation(.easeInOut(duration: 0.8), value: flipped)
                
                
                ZStack() {
                    HStack {
                        ZStack{
                            Text("0")
                                .font(.largeTitle.bold())
                                .frame(width: 80, height: 80)
                                .foregroundColor(.white)
                                .roundedRectBackground(radius: 8, fill: .secondary) .flipVRotate(frontDegrees).opacity(flipped ? 0.0 : 1.0)
                            
                            ZStack {
                                Text("1")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 80).roundedRectBackground(radius: 8, fill: .secondary)
                                    .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                            }
                            .flipVRotate(backDegrees).opacity(flipped ? 1.0 : 0.0)
                        }
                        
                        Text("2")
                            .frame(width: 80, height: 80)
                            .roundedRectBackground(radius: 8, fill: Color(.blue))
                    }
                    
                }
                .animation(.easeInOut(duration: 0.8), value: flipped)
                
                Spacer()
                
                Button {
                    self.flipped.toggle()
                    frontDegrees = frontDegrees + 180
                } label: {
                    Text("flip")
                }
                
            }
        }
        
    }
}



struct ManageScreen_Previews: PreviewProvider {
    static var previews: some View {
        ManageScreen()
    }
}
