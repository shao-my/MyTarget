//
//  MyTargetApp.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

@main
struct AppEntry: App {
    //let persistenceController = PersistenceController.shared
    
    init() {
        applyTabBarBackground()
        UITabBar.appearance().isHidden = true
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
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
