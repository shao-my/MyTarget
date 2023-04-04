//
//  CustomTabBar.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/27.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: HomeScreen.Tab
    @State var yOffset: CGFloat = 0
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            HStack(spacing: 0) {
                ForEach(HomeScreen.Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)){
                            currentTab = tab
                            yOffset = -60
                        }
                        withAnimation(.easeInOut(duration: 0.1).delay(0.07)){
                            yOffset = 0
                        }
                    } label: {
                        Image(systemName: tab.rawValue)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color.purple : .accentColor)
                            .scaleEffect(currentTab == tab && yOffset != 0 ? 1.5 : 1)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 25, height: 25)
                    .offset(x: 20, y: yOffset)
                    .offset(x: indicatorOffset(width: width))
            }
        }
        .frame(height: 30)
        .padding(.bottom, 10)
        .padding([.horizontal,.top])
    }
    
    func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getTabIndex())
        if index == 0 { return 0 }
        
        let buttonWith = width / CGFloat(HomeScreen.Tab.allCases.count)
        return index * buttonWith
    }
    
    func getTabIndex() -> Int {
        switch currentTab {
        case .summary:
            return 0
        case .timer:
            return 1
        case .manage:
            return 2
        case .settings:
            return 3
        }
    }
}

