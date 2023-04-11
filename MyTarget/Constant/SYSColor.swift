//
//  SYSColor.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/18.
//

import SwiftUI

enum SYSColor: String, CaseIterable {
    case gray = "gray"
    case blue = "blue"
    case red = "red"
    case cyan = "cyan"
    //case fill = "fill"
    case mint = "mint"
    case pink = "pink"
    case teal = "teal"
    case brown = "brown"
    case indigo = "indigo"
    case oragne = "orange"
    case purple = "purple"
    case yellow = "yellow"
    case green = "green"
    
    var create: UIColor {
           switch self {
           case .gray:
               return UIColor(.secondary)
               // return UIColor(Color(.tertiarySystemFill))
           case .blue:
                return UIColor.systemBlue
           case .red:
                return UIColor.systemRed
           case .cyan:
                return UIColor.systemCyan
          // case .fill:
          //      return UIColor.systemFill
           case .mint:
                return UIColor.systemMint
           case .pink:
                return UIColor.systemPink
           case .teal:
                return UIColor.systemTeal
           case .brown:
                return UIColor.systemBrown
           case .indigo:
                return UIColor.systemIndigo
           case .oragne:
                return UIColor.systemOrange
           case .purple:
                return UIColor.systemPurple
           case .yellow:
                return UIColor.systemYellow
           case .green:
                return UIColor.systemGreen 
           }
        }
}
 

 

