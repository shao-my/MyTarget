//
//  TextAnimation.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/4.
//

import SwiftUI

struct TextAnimation: Identifiable {
    var id = UUID().uuidString
    var text: String
    var offset: CGFloat = 50
}
