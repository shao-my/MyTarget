//
//  ColorGrid.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/22.
//

import SwiftUI

struct ColorGrid: Identifiable {
    var id = UUID().uuidString
    var hexValue: String
    var color: Color
    var rotateCards: Bool = false
    var addToGrid: Bool = false
    var showText: Bool = false
    var removeFromView: Bool = false
}
 
