//
//  MyTargetApp.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

@main
struct AppEntry: App {
    let persistenceController = PersistenceController.shared
    @StateObject var pomodoroModel: PomodoroModel = .init()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        applyTabBarBackground()
        UITabBar.appearance().isHidden = true 
    }
    
    var body: some Scene {
        WindowGroup {   
            HomeScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(pomodoroModel)
        }
    }
    
    func applyTabBarBackground() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.3)
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}



class AppDelegate: NSObject,UIApplicationDelegate,UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        if UIApplication.shared.haveDynamicIsland {
            return [.sound]
        } else {
            return [.sound,.banner]
        }
    }
}

extension UIApplication {
    var haveDynamicIsland: Bool {
        return deviceName == "iPhone 14 Pro" || deviceName == "iPhone 14 Pro Max"
    }
    
    var deviceName: String {
        return UIDevice.current.name
    }
}
