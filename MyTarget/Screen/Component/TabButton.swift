//
//  TabButton+.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/17.
//

import SwiftUI

struct TabButton: View {
    var title: String
    var image: SFSymbol
    var tag: HomeScreen.Tab
    
    @Binding var selected: HomeScreen.Tab

    
    var body: some View {
        Button {
            withAnimation(.spring()){ selected = tag }
        } label: {
            HStack(spacing: 10) {
                Image(systemName:  image)
             //   SFSymbol.house
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
                
                if selected == tag {
                    Text(title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical,10)
            .padding(.horizontal)
            .background(Color.white.opacity(selected == tag ? 0.08 : 0))
            .clipShape(Capsule())
        }

    }
}
