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
    var startTime: String
    var endTime: String
    
}

extension QuartzPrms {
    static var new: QuartzPrms {
        return QuartzPrms( quartzName: "",
                           quartzType: "HOLD",
                           quartzTimes: "0",
                           quartzWay: "BOOL",
                           quartzIcon: "pencil.and.outline",
                           quartzColor: "gray",
                           dayTime: getStringForYYYYMMDD(dateTime: Date()),
                           startDay: getStringForYYYYMMDD(dateTime: Date()),
                           endDay:  "",
                           startTime: getStringForYYYYMMDD(dateTime: Date()) + " " + "09:00",
                           endTime:  ""
        )
    }
    
    static var newHold: QuartzPrms {
        return QuartzPrms( quartzName: "",
                           quartzType: "HOLD",
                           quartzTimes: "0",
                           quartzWay: "BOOL",
                           quartzIcon: "pencil.and.outline",
                           quartzColor: "gray",
                           dayTime: getStringForYYYYMMDD(dateTime: Date()),
                           startDay: getStringForYYYYMMDD(dateTime: Date()),
                           endDay:  "",
                           startTime: getStringForYYYYMMDD(dateTime: Date()) + " " + "09:00",
                           endTime:  ""
        )
    }
    
    static var newQuit: QuartzPrms {
        return QuartzPrms( quartzName: "",
                           quartzType: "QUIT",
                           quartzTimes: "0",
                           quartzWay: "BOOL",
                           quartzIcon: "pencil.and.outline",
                           quartzColor: "gray",
                           dayTime: getStringForYYYYMMDD(dateTime: Date()),
                           startDay: getStringForYYYYMMDD(dateTime: Date()),
                           endDay:  "",
                           startTime: getStringForYYYYMMDD(dateTime: Date()) + " " + "09:00",
                           endTime:  ""
        )
    }
    
    static func newPrmsByQuartz(quartz: Quartz) -> QuartzPrms {
        return QuartzPrms( id: quartz.id ?? UUID(),
                           quartzName: quartz.quartzName ?? "目标",
                           quartzType: quartz.quartzType ?? "HOLD",
                           quartzTimes: String(quartz.quartzTimes),
                           quartzWay: quartz.quartzWay ?? "BOOL",
                           quartzIcon: quartz.quartzIcon ?? "pencil.and.outline",
                           quartzColor: quartz.quartzColor ?? "gray",
                           dayTime:  getStringForYYYYMMDD(dateTime: Date()),
                           startDay: quartz.startDay!,
                           endDay: quartz.endDay ?? "",
                           startTime: quartz.startTime!,
                           endTime:  quartz.endTime ?? ""
        )
    }
    
    static let examples = [
        QuartzPrms(quartzName: "",
                   quartzType: "HOLD",
                   quartzTimes: "0",
                   quartzWay: "BOOL",
                   quartzIcon: "pencil.and.outline",
                   quartzColor: "gray",
                   dayTime: getStringForYYYYMMDD(dateTime: Date()),
                   startDay: getStringForYYYYMMDD(dateTime: Date()),
                   endDay:  "",
                   startTime: getStringForYYYYMMDD(dateTime: Date()) + " " + "09:00",
                   endTime:  ""
                  )
    ]
    
    
}

extension QuartzPrms: Codable {}

