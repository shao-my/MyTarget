//
//  QuartzCard.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/26.
//

import SwiftUI

struct QuartzCard: Identifiable {
    var id: String = UUID().uuidString
    var quartz: Quartz
    var isRotated: Bool = false
    var extraOffset: CGFloat = 0
    var scale: CGFloat = 1
    var zIndex: Double = 0
 }

 
