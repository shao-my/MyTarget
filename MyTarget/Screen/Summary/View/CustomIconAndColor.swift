//
//  CustomIconAndColor.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/16.
//

import SwiftUI

struct CustomIconAndColor: View {
    // @State var tab: Tab = CustomIconAndColor.Tab.iconView
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    
    @State var tab: String = "iconView"
    @State var icon: SFSymbol = .def
    
    // @State var selectedIcon: String
    // @State var selectedColor: String
    
    @Binding var customItem: QuartzPrms
    @State var taps: Int = 0 
    @State var loveCount: Int = 0
    @Namespace var tabAnimation
    
    var body: some View {
        
        VStack {
            HStack {
                Text("目标装饰配置")
                    .font(.title3.bold())
                    .overlay(
                        Rectangle().frame(height: 2).offset(y: 4)
                        , alignment: .bottom
                    )
                //.underline(color: .secondary)
                    .push(to: .center)
            }
            .padding()
            
            ZStack {
                ForEach(0 ..< loveCount, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color(SYSColor(rawValue: customItem.quartzColor)!.create))
                        .modifier(LoveTapModifier())
                        .padding()
                }
                
                 Button {
                    withAnimation {
                        loveCount = loveCount + 20
                    }
                } label: {
                    Image(systemName: customItem.quartzIcon)
                        .resizable()
                        .padding()
                        .frame(width: 80, height: 80)
                        .bold()
                        .foregroundColor(.white)
                }
                .buttonStyle(.bordered)
                .roundedRectBackground(radius: 8, fill:Color(SYSColor(rawValue: customItem.quartzColor)!.create))
                .padding()
               
            }
            .bounce(animCount: taps)
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1), value: customItem.quartzColor)
            
            
            HStack {
                Text("图标设置")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 25)
                    .background (
                        ZStack {
                            if tab == "iconView" {
                                Color.white
                                    .cornerRadius(10)
                                    .matchedGeometryEffect(id: "TABANIMATION", in: tabAnimation)
                            }
                        }
                    )
                    .foregroundColor( tab == "iconView" ? .black : .white)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                            tab = "iconView"
                        }
                    }
                
                Text("颜色设置")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 25)
                    .background (
                        ZStack {
                            if tab == "colorView" {
                                Color.white
                                    .cornerRadius(10)                                    .matchedGeometryEffect(id: "TABANIMATION", in: tabAnimation)

                            }
                        }
                    )
                    .foregroundColor( tab == "colorView" ? .black : .white)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                            tab = "colorView"
                        }
                    }

            }
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(shouldUseDarkMode ? Color.gray.opacity(0.15) : Color.gray.opacity(0.25))
            .cornerRadius(10)
            .padding(.bottom)
               
            
           /* HStack (spacing: 20){
                ZStack{
                    Text("")
                        .frame(height: 40)
                        .push(to: .center)
                        .roundedRectBackground(radius: 8, fill: tab == "iconView" ? Color.blue : Color(.tertiarySystemFill) )
                        .onTapGesture {
                            tab = "iconView"
                        }
                        .id(tab == "iconView")
                        .transition(.move(edge: .leading).combined(with: .opacity).animation(.easeInOut))
                    
                    Text("图标设置")
                        .bold()
                        .frame(height: 40)
                        .push(to: .center)
                        .foregroundColor( tab == "iconView" || shouldUseDarkMode  ? .white : .black)
                        .roundedRectBackground(radius: 8, fill: tab == "iconView" ?  Color(SYSColor(rawValue: customItem.quartzColor)!.create) : Color(.tertiarySystemFill) )
                        .onTapGesture {
                            tab = "iconView"
                        }
                }
                
                ZStack{
                    Text("")
                        .frame(height: 40)
                        .push(to: .center)
                        .roundedRectBackground(radius: 8, fill: tab ==  "colorView" ? Color.pink : Color(.tertiarySystemFill) )
                        .onTapGesture {
                            tab = "colorView"
                        }
                        .id(tab == "colorView")
                        .transition(.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut))
                    
                    Text("颜色设置")
                        .bold()
                        .frame(height: 40)
                        .push(to: .center)
                        .foregroundColor( tab == "colorView" || shouldUseDarkMode ? .white : .black)
                        .roundedRectBackground(radius: 8, fill: tab ==  "colorView" ? Color.pink : Color(.tertiarySystemFill) )
                        .onTapGesture {
                            tab = "colorView"
                        }
                }
            }
            .padding(.vertical)
            .padding(.horizontal,40)
            .animation(.mySpring, value: tab)
            */
            
            TabView(selection: $tab) {
                CustomIcon(customItem: $customItem,taps: $taps).tag("iconView").tabItem {}
            
                CustomColor(customItem: $customItem,loveCount: $loveCount).tag("colorView").tabItem {}
            }
            .tabViewStyle(.page)
        }
        .background(.groupBg)
        .multilineTextAlignment(.trailing)
        
    }
    
    func builderNutritionView(title: String) -> some View{
        GridRow{
            Text(title)
        }.gridCellAnchor(.leading)
    }
}

 
/*
 extension CustomIconAndColor {
 enum Tab:String, View, CaseIterable {
 case iconView,colorView
 
 var body: some View {
 content.tabItem {
 //tabLabel.labelStyle(.iconOnly)
 }
 }
 
 @ViewBuilder
 private var content: some View {
 switch self {
 case .iconView:   CustomIcon(customItem:)
 case .colorView: Text("2")
 }
 }
 
 private var tabLabel: some View {
 switch self {
 case .iconView:
 return Label("Home", systemImage: .house)
 case .colorView:
 return Label("List", systemImage: .list)
 
 }
 }
 }
 }
 */

struct CustomIconAndColor_Previews: PreviewProvider {
    static var previews: some View {
        CustomIconAndColor(customItem: .constant(QuartzPrms.examples[0]))
    }
}


