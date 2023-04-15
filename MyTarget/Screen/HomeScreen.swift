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
    
    @EnvironmentObject var pomodoroModel: PomodoroModel
    @State var lastActiveTimeStamp: Date = Date()
    
    @EnvironmentObject var openUrl: OpenUrlModel
    
    @Namespace var animationForHome
    @State var animationStates: [Bool] = Array(repeating: false, count: 3)
    //let bgColor: Color = Color(red: 120 / 255, green: 96 / 255, blue: 160 / 255)
    
    var body: some View {
        ZStack{
            if !animationStates[1]   {
                ZStack {
                    RoundedRectangle(cornerRadius:  40,style: .continuous)
                        .fill(Color("Purple"))
                        .ignoresSafeArea()
                        
                    Image("Check")
                    .scaleEffect(animationStates[0] ? 0.25 : 1)
                }
                .zIndex(999)
                .matchedGeometryEffect(id: "LOGO", in: animationForHome)
            }
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                if isLocked {
                    FaceIDView()
                }
                
                TabView(selection: $openUrl.currentTab) {
                    ForEach(Tab.allCases, id: \.self){
                        $0
                            .environmentObject(pomodoroModel)
                            .environmentObject(openUrl)
                            .overlay(alignment: .topTrailing) {
                                if animationStates[0]    {
                                    ZStack {
                                        RoundedRectangle(cornerRadius:  40  ,style: .continuous)
                                            .fill(Color("Purple"))
                                            .frame(width: 40,height: 40)
                                            
                                        Image("Check")
                                        .scaleEffect( 0.25 )
                                    }
                                    .matchedGeometryEffect(id: "LOGO", in: animationForHome)
                                   // .offset(x: 65,y: 16)
                                    .opacity(openUrl.currentTab == .summary ? 1 : 0)
                                }
                            }
                    }
                }
                .preferredColorScheme(shouldUseDarkMod ? .dark : .light)  //只向上传递一层
                
                CustomTabBar(currentTab: $openUrl.currentTab)
                    .zIndex(9)
                    .background(.bg2)
            }
        }
        .onAppear {
            if isOpenFaceIdLock {
                isLocked = true
                faceIDModel.authenticate()
            }
        }
        .onAppear(perform: startAnimations)
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
                }
            }
        }
    }
    
    func startAnimations(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeIn) {
                animationStates[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                animationStates[1] = true
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(PomodoroModel())
            .environmentObject(OpenUrlModel())
    }
}
