//
//  SettingsScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
import StoreKit

struct SettingsScreen: View {
    @AppStorage(.shouldUseDarkMode) private var shouldUseDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        Form {
            Section("基本设定") {
                Toggle(isOn: $shouldUseDarkMode){
                    Label("深色模式", systemImage: .moon)
                }
                .toggleStyle(.switch)
            }
            
            Section("评价建议") {
                Button("君子曰：从善如流，宜哉。") {
                    requestReview()
                }.tint(Color(.label))
                
            }
        }
        
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
