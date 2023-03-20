//
//  CustomColor.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/18.
//

import SwiftUI

struct CustomColor: View {
    @Binding var customItem: QuartzPrms
    @Binding var loveCount: Int
    
    var gridItemLayout = [GridItem.init(.flexible(), spacing: 0, alignment: .center),                                                GridItem.init(.flexible(), spacing: 0, alignment: .center),
                          GridItem.init(.flexible(), spacing: 0, alignment: .center)]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(SYSColor.allCases, id: \.self){ color in
                    Text("")
                    //Color(SYSColor(rawValue: color.rawValue)!.create)
                        .frame(width: 30, height: 30)
                        .padding()
                        .roundedRectBackground(radius: 100, fill: Color(SYSColor(rawValue: color.rawValue)!.create))
                        .onTapGesture {
                            customItem.quartzColor = color.rawValue
                            loveCount = loveCount + 20
                        }
                }
            }
            .padding(.horizontal)
        }
        
    }
}

struct CustomColor_Previews: PreviewProvider {
    static var previews: some View {
        CustomColor(customItem: .constant(QuartzPrms.examples[0]), loveCount: .constant(0))
    }
}
