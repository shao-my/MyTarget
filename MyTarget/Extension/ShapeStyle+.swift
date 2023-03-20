//
//  ShapeStyle+.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI
 
extension ShapeStyle where Self == Color {
    static var bg: Color { Color(.systemBackground) }
    static var bg2: Color { Color(.secondarySystemBackground) }
    static var groupBg: Color { Color(.systemGroupedBackground) }
    static var groupBg2: Color { Color(.secondarySystemGroupedBackground) }
    
    // MARK: theme-color
    static var gray: Color { .blue }
    static var blue: Color { Color(.systemBlue) }
    static var red: Color { Color(.systemRed) }
    static var cyan: Color { Color(.systemCyan) }
    static var pink: Color { Color(.systemPink) } 
}
 
 
