//
//  Food.swift
//  FoodPicker
//
//  Created by Jane Chao on 22/10/09.
//

import Foundation
import SwiftUI

struct QuartzPrms: Equatable, Identifiable {
    var id = UUID()
    var quartzName: String
    var quartzType: String
    var quartzTimes: String
    var quartzWay: String
    var quartzIcon: String
    var quartzColor: String
    var dayTime: String
    var startDay: String
    var endDay: String
    var startTime: Date
    var endTime: Date
    var isEveryDay: Bool
    var isHourRange: Bool
    
}

extension QuartzPrms {
    static var new: QuartzPrms {
        return QuartzPrms( quartzName: "",
                           quartzType: "HOLD",
                           quartzTimes: "0",
                           quartzWay: "BOOL",
                           quartzIcon: SFSymbol.def.rawValue,
                           quartzColor: "gray",
                           dayTime: getStringForYYYYMMDD(dateTime: Date()),
                           startDay: getStringForYYYYMMDD(dateTime: Date()),
                           endDay:  "",
                           startTime: Date(),
                           endTime:  Date(),
                           isEveryDay: true,
                           isHourRange: false
        )
    }
    
    static var newHold: QuartzPrms {
        return QuartzPrms( quartzName: "",
                           quartzType: "HOLD",
                           quartzTimes: "0",
                           quartzWay: "BOOL",
                           quartzIcon: SFSymbol.def.rawValue,
                           quartzColor: "gray",
                           dayTime: getStringForYYYYMMDD(dateTime: Date()),
                           startDay: getStringForYYYYMMDD(dateTime: Date()),
                           endDay:  "",
                           startTime: Date(),
                           endTime:  Date(),
                           isEveryDay: true,
                           isHourRange: false
        )
    }
    
    static var newQuit: QuartzPrms {
        return QuartzPrms( quartzName: "",
                           quartzType: "QUIT",
                           quartzTimes: "0",
                           quartzWay: "BOOL",
                           quartzIcon: SFSymbol.def.rawValue,
                           quartzColor: "gray",
                           dayTime: getStringForYYYYMMDD(dateTime: Date()),
                           startDay: getStringForYYYYMMDD(dateTime: Date()),
                           endDay:  "",
                           startTime: Date(),
                           endTime:  Date(),
                           isEveryDay: true,
                           isHourRange: false
        )
    }
    
    static func newPrmsByQuartz(quartz: Quartz) -> QuartzPrms {
        return QuartzPrms( id: quartz.id ?? UUID(),
                           quartzName: quartz.quartzName ?? "目标",
                           quartzType: quartz.quartzType ?? "HOLD",
                           quartzTimes: String(quartz.quartzTimes),
                           quartzWay: quartz.quartzWay ?? "BOOL",
                           quartzIcon: quartz.quartzIcon ??  SFSymbol.def.rawValue,
                           quartzColor: quartz.quartzColor ?? "gray",
                           dayTime:  getStringForYYYYMMDD(dateTime: Date()),
                           startDay: quartz.startDay!,
                           endDay: quartz.endDay ?? "",
                           startTime: quartz.startTime!,
                           endTime:  quartz.endTime ?? Date(),
                           isEveryDay: true,
                           isHourRange: false
        )
    }
    
    static let examples = [
        QuartzPrms(quartzName: "",
                   quartzType: "HOLD",
                   quartzTimes: "0",
                   quartzWay: "BOOL",
                   quartzIcon: SFSymbol.def.rawValue,
                   quartzColor: "gray",
                   dayTime: getStringForYYYYMMDD(dateTime: Date()),
                   startDay: getStringForYYYYMMDD(dateTime: Date()),
                   endDay:  "",
                   startTime: Date(),
                   endTime:  Date(),
                   isEveryDay: true,
                   isHourRange: false
                  )
    ]
    
    
}

extension QuartzPrms: Codable {}

