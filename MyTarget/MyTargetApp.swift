//
//  MyTargetApp.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

@main
struct MyTargetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
