//
//  SFSymbol.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

enum SFSymbol: String, CaseIterable {
    case pencil
    case plus = "plus.circle.fill"
    case xmark = "xmark.circle.fill"
    case info = "info.circle.fill"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case forkAndKnife = "fork.knife.circle"
    
    case moon = "moon.fill"
    case uninSign = "numbersign"
    case house = "house.fill"
    case list = "list.bullet"
    case gear = "gearshape"
    
    case flag = "flag.square"
    case time = "timer.square"
    case type = "command.square"
    case way = "heart.square"
    case num = "number.square"
    case end = "arrow.left.square"
    case start = "arrow.right.square"
    case loop = "clock.arrow.2.circlepath"
    
    // MARK: sheme-icon
    case def = "medal.fill"
    case arrowRight = "arrow.right"
    case arrowLeft = "arrow.left"
    case thumbsup = "hand.thumbsup.circle"
    case calender = "calendar.circle"
    case target = "target"
    case chevronLeft =  "chevron.left"
    case chevronRight =  "chevron.right"
    //case medal = "medal.fill"

    case edit = "square.and.pencil"
}

extension Label where Title == Text, Icon == Image  {
    init(_ text: String,systemImage: SFSymbol){
        self.init(text,systemImage: systemImage.rawValue)
    }
}

extension Image {
    init(systemName: SFSymbol){
        self.init(systemName: systemName.rawValue)
    }
}

extension SFSymbol: View {
    var body: Image {
        Image(systemName: rawValue)
    }
    
    func resizable () -> Image {
        return self.body.resizable()
    }
}


