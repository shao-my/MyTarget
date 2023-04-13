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
    @StateObject var dayBookModel: DayBookModel = DayBookModel()
    @Environment(\.self) var env
    
    @AppStorage(.isOpenFaceIdLock) private var isOpenFaceIdLock: Bool = false
    @AppStorage(.isUnlocked) private var isLocked: Bool = false
    @StateObject var faceIDModel : FaceIDModel = FaceIDModel()
    @Environment(\.scenePhase) var scenePhase
    
    @State var tab: Tab = {
        let rawValue = UserDefaults.standard.string(forKey: UserDefaults.Key.startTab.rawValue) ?? ""
        return Tab(rawValue: rawValue) ?? .summary
    }()
    
    @State var currentTab = "概要"
    
    @EnvironmentObject var pomodoroModel: PomodoroModel
    @State var lastActiveTimeStamp: Date = Date() 
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            if isLocked {
                FaceIDView()
            }
            
            TabView(selection: $tab) {
                ForEach(Tab.allCases, id: \.self){ $0.environmentObject(pomodoroModel) }
            }
            .preferredColorScheme(shouldUseDarkMod ? .dark : .light)  //只向上传递一层
            
           
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
                dayBookModel.initDayBooks(context: env.managedObjectContext)
               
                if pomodoroModel.isStarted && !pomodoroModel.isPaused {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if pomodoroModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        pomodoroModel.isStarted = false
                        pomodoroModel.totalSeconds = 0
                        pomodoroModel.isFinished = true
                        pomodoroModel.isPaused = false
                    }else{
                        pomodoroModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                   // app.endBackgroundTask()
                }
            } else if newPhase == .inactive {
                if isOpenFaceIdLock {
                    isLocked = true
                }
            } else if newPhase == .background {
                if isOpenFaceIdLock {
                    isLocked = true
                }
               
                if pomodoroModel.isStarted {
                    lastActiveTimeStamp = Date()
                    /*let app = UIApplication.shared
                    app.beginBackgroundTask(withName: "MyTarget") {
                        print("MyTarget: Start")
                    }*/
                }
            }
        }
    }
     
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
