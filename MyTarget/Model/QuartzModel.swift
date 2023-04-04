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
    @Published var status: Bool = true
    @Published var isEveryDay: Bool = true
    @Published var isHourRange: Bool = false
    
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
        quartz.status = true
        quartz.isEveryDay = quartzPrms.isEveryDay
        quartz.isHourRange = quartzPrms.isHourRange
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
    
    func editQuartz(context: NSManagedObjectContext,quartzPrms: QuartzPrms) {
        //查询有效Quartz
        var quartzs: [Quartz] = []
        let requestQuartz = NSFetchRequest<Quartz>(entityName: "Quartz")
        requestQuartz.predicate =  NSPredicate(format: "id = %@", quartzPrms.id as CVarArg)
        do {
            try quartzs = context.fetch(requestQuartz)
        } catch let error {
            print(error.localizedDescription)
        }
        
        if quartzs.count > 0 {
            //let quartz = Quartz(context: context)
            let quartz = quartzs[0]
            //quartz.id = quartzPrms.id
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
            // quartz.status = quartzPrms.status
            quartz.isEveryDay = quartzPrms.isEveryDay
            quartz.isHourRange = quartzPrms.isHourRange
            try? context.save()
        }
        
        
        //只修改当天的DayBook
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        requestDayBook.predicate = NSPredicate(format: "quartzId = %@ and dayTime = %@", quartzPrms.id as CVarArg,getStringForYYYYMMDD())
        do {
            try dayBooks = context.fetch(requestDayBook)
        } catch let error {
            print(error.localizedDescription)
        }
        if dayBooks.count > 0 {
            for book in dayBooks {
                book.quartzName = quartzPrms.quartzName
                book.quartzType = quartzPrms.quartzType
                book.quartzTimes = Int16((quartzPrms.quartzTimes as NSString).intValue)
                book.quartzWay = quartzPrms.quartzWay
                book.quartzIcon = quartzPrms.quartzIcon
                book.quartzColor = quartzPrms.quartzColor
                book.startTime = quartzPrms.startTime
                book.endTime = quartzPrms.endTime
                try? context.save()
            }
        }
    }
    
    func delQuartz(context: NSManagedObjectContext,quartz: Quartz) {
        let id =  quartz.id
        //查询有效Quartz
        var quartzs: [Quartz] = []
        let requestQuartz = NSFetchRequest<Quartz>(entityName: "Quartz")
        requestQuartz.predicate =  NSPredicate(format: "id = %@", id! as CVarArg)
        do {
            try quartzs = context.fetch(requestQuartz)
        } catch let error {
            print(error.localizedDescription)
        }
        
        if quartzs.count > 0 {
            let quartz = quartzs[0]
            context.delete(quartz)
            try? context.save()
        }
        
        
        //只修改当天的DayBook
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        requestDayBook.predicate = NSPredicate(format: "quartzId = %@ and dayTime = %@", id! as CVarArg ,getStringForYYYYMMDD())
        do {
            try dayBooks = context.fetch(requestDayBook)
        } catch let error {
            print(error.localizedDescription)
        }
        if dayBooks.count > 0 {
            for book in dayBooks {
                 context.delete(book)
                try? context.save()
            }
        }
    }
    
    func fetchQuartzList(context: NSManagedObjectContext) -> [Quartz] {
        var quartzList: [Quartz] = []
        let request = NSFetchRequest<Quartz>(entityName: "Quartz")
        request.predicate = NSPredicate(format: "status = %@", "1")
        do {
            quartzList = try context.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
        return quartzList
    }
}

