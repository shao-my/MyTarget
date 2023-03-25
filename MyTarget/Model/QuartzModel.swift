//
//  QuartzModel.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/24.
//

import SwiftUI
import CoreData

class QuartzModel: ObservableObject {
    @Published var quartzName: String =  ""
    @Published var quartzType: String  = ""
    @Published var quartzTimes: String  = "0"
    @Published var quartzWay: String  = ""
    @Published var quartzIcon: String  = SFSymbol.def.rawValue
    @Published var quartzColor: String  = "gray"
    @Published var isEvaryDay: Bool  = true
    @Published var startDay: String  =  getStringForYYYYMMDD(dateTime: Date())
    @Published var endDay: String  = ""
    @Published var startTime: Date  = Date()
    @Published var endTime: Date = Date()
    
    
    func addQuartz(context: NSManagedObjectContext,quartzPrms: QuartzPrms) {
        let quartz = Quartz(context: context)
        
        quartz.id = quartzPrms.id
        quartz.quartzName = quartzPrms.quartzName
        quartz.quartzType = quartzPrms.quartzType
        quartz.quartzTimes = Int16((quartzPrms.quartzTimes as NSString).intValue)
        quartz.quartzWay = quartzPrms.quartzWay
        quartz.quartzIcon = quartzPrms.quartzIcon
        quartz.quartzColor = quartzPrms.quartzColor
        quartz.startDay = quartzPrms.startDay
        quartz.endDay = quartzPrms.endDay
        quartz.startTime =   quartzPrms.startTime
        quartz.endTime = quartzPrms.endTime
        
        try? context.save()
        
        //新增Quartz时自动插入一条DayBook信息,避免当天维护任务无法刷新页面
        let dayBook = DayBook(context: context)
        dayBook.id = UUID()
        dayBook.quartzId = quartzPrms.id
        dayBook.quartzName = quartzPrms.quartzName
        dayBook.dayTime =  quartzPrms.startDay
        dayBook.isCompleted = false
        dayBook.quartzType = quartzPrms.quartzType
        dayBook.quartzIcon = quartzPrms.quartzIcon
        dayBook.quartzColor = quartzPrms.quartzColor
        dayBook.quartzTimes =  Int16((quartzPrms.quartzTimes as NSString).intValue)
        dayBook.completedTimes = .zero
        dayBook.quartzWay = quartzPrms.quartzWay
        dayBook.startTime = quartzPrms.startTime
        dayBook.endTime = quartzPrms.endTime
       
        try? context.save()
    }
}
 
