//
//  HomeScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

extension HomeScreen {
    enum Tab:String, View, CaseIterable {
        case summary,manage,settings
        
        var body: some View {
            content.tabItem { tabLabel }
        }
        
        @ViewBuilder
        private var content: some View {
            switch self {
            case .summary: SummaryScreen()
            case .manage: ManageScreen()
            case .settings: SettingsScreen()
            }
        }
        
        private var tabLabel: some View {
            switch self {
            case .summary:
                return Label("概要", systemImage: .house)
            case .manage:
                return Label("管理", systemImage: .list)
            case .settings:
                return Label("设置", systemImage: .gear)
            }
        }
    }
}


struct HomeScreen: View {
    @AppStorage(.shouldUseDarkMode) var shouldUseDarkMod = false
    @State var tab: Tab = {
        let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.startTab.rawValue) ?? ""
        return Tab(rawValue: rawValue) ?? .summary
        
        //只是取一次出来，返回
        //@AppStorage(.startTab) var tab = HomeScreen.Tab.settings
        //return tab
    }()
    
    @State var currentTab = "概要"
    
    var body: some View {
        //包一层NavigationStack或者NavigationView就正常了
        // NavigationStack{
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $tab) {
                ForEach(Tab.allCases, id: \.self){ $0 }
            }
            .preferredColorScheme(shouldUseDarkMod ? .dark : .light)  //只向上传递一层
            
            HStack(spacing: 0) {
                TabButton(title: "概要", image: .house, tag: .summary, selected: $tab)
                Spacer(minLength: 0)
                TabButton(title: "管理", image: .list, tag: .manage,selected: $tab)
                Spacer(minLength: 0)
                TabButton(title: "设置", image: .gear, tag: .settings,selected: $tab)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(Color("TabBgColor"))
            .clipShape(Capsule())
            .padding(.horizontal,25)
        }
        
        //   }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}