//
//  CustomIcon.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/17.
//

import SwiftUI

struct CustomIcon: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false

    @Binding var customItem: QuartzPrms
    @Binding var taps: Int
    
    var gridItemLayout = [GridItem.init(.flexible(), spacing: 0, alignment: .center),                                                GridItem.init(.flexible(), spacing: 0, alignment: .center),
                          GridItem.init(.flexible(), spacing: 0, alignment: .center)]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(SFSymbol.allCases, id: \.self){ icon in
                    Button {
                        customItem.quartzIcon = icon.rawValue
                        withAnimation(Animation.linear(duration: 1)) {
                          taps += 1
                        }
                    } label: {
                        icon
                            .font(.title)
                            .frame(width: 30, height: 30)
                            .padding()
                            .roundedRectBackground(radius: 8, fill: Color(SYSColor(rawValue: customItem.quartzColor)!.create))
                            .foregroundColor(.white)
                        
                    }
                    //.buttonStyle(.bordered)
                   // .roundedRectBackground(radius: 100, fill:Color(SYSColor(rawValue: customItem.quartzColor)!.create))
                }
            }
            .padding(.horizontal) 
        }
        
    }
}

struct CustomIcon_Previews: PreviewProvider {
    static var previews: some View {
        CustomIcon(customItem: .constant(QuartzPrms.examples[0]),taps: .constant(0))
    }
}
