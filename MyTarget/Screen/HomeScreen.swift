//
//  HomeScreen.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

extension HomeScreen {
    enum Tab:String, View, CaseIterable {
        case summary = "hand.thumbsup"
        case timer =  "calendar"
        case manage = "scope"
        case settings = "gearshape"
        
        var body: some View {
            content.tabItem { tabLabel }
        }
        
        @ViewBuilder
        private var content: some View {
            switch self {
            case .summary: SummaryScreen()
            case .timer: TimerScreen()
            case .manage: QuartzScreen()
            case .settings: SettingsScreen()
            }
        }
        
        private var tabLabel: some View {
            switch self {
            case .summary:
                return Label("概要", systemImage: .house)
            case .timer:
                return Label("时间", systemImage: .target)
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
    
    
    @AppStorage(.isOpenFaceIdLock) private var isOpenFaceIdLock: Bool = false
    @AppStorage(.isUnlocked) private var isLocked: Bool = false
    @StateObject var faceIDModel : FaceIDModel = FaceIDModel()
    @Environment(\.scenePhase) var scenePhase
    
    
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
            if isLocked {
                FaceIDView()
            }
            
            TabView(selection: $tab) {
                ForEach(Tab.allCases, id: \.self){ $0 }
            }
            .preferredColorScheme(shouldUseDarkMod ? .dark : .light)  //只向上传递一层
            
          /*  HStack(spacing: 0) {
                TabButton(title: "概要", image: .thumbsup, tag: .summary, selected: $tab)
                Spacer(minLength: 0)
                TabButton(title: "时间", image: .calender, tag: .timer,selected: $tab)
                Spacer(minLength: 0)
                TabButton(title: "目标", image: .target, tag: .manage,selected: $tab)
                Spacer(minLength: 0)
                TabButton(title: "设置", image: .gear, tag: .settings,selected: $tab)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(Color("TabBgColor"))
            .clipShape(Capsule())
            .padding(.horizontal,25)*/
            
            CustomTabBar(currentTab: $tab)
                .zIndex(999)
                .background(.bg2)
        }
        .onAppear {
            if isOpenFaceIdLock {
                isLocked = true
                faceIDModel.authenticate()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                
            } else if newPhase == .inactive {
                if isOpenFaceIdLock {
                    isLocked = true
                }
            } else if newPhase == .background {
                if isOpenFaceIdLock {
                    isLocked = true
                }
            }
        }
        //   }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
