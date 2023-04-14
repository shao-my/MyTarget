//
//  OpenUrlModel.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/14.
//

import SwiftUI

class OpenUrlModel: ObservableObject {
    @Published var currentTab: HomeScreen.Tab = HomeScreen.Tab.summary
    @Published var internalLink: String?
    
    func checkDeepLink(url: URL) -> Bool {
        guard let host = URLComponents(url: url, resolvingAgainstBaseURL: true)?.host else {
            return false
        }
        
        if host == HomeScreen.Tab.summary.rawValue {
            currentTab = .summary
        }else if host == HomeScreen.Tab.timer.rawValue {
            currentTab = .timer
        }else if host == HomeScreen.Tab.manage.rawValue {
            currentTab = .manage
        }else if host == HomeScreen.Tab.settings.rawValue {
            currentTab = .settings
        }else{
            return checkInternalLinks(host: host)
        }  
        return true
    }
    
    func checkInternalLinks(host: String) -> Bool {
        //单独URL配置
        if host == "pomodoroTimer" {
            currentTab = .settings
            internalLink = host
            return true
        }
        return false
    }
}
 
