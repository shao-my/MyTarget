//
//  QuartzModel.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/24.
//

import SwiftUI
import CoreData
import UserNotifications

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
    
    //add
    @Published var weekDays: String = ""
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    
    @Published var notificationAccess: Bool = false
    
    init(){
        requestNotificationAccess()
    }
    
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
        
        //add
        quartz.weekDays = quartzPrms.weekDays.joined(separator: ",")
        quartz.isRemainderOn = quartzPrms.isRemainderOn
        quartz.remainderText = quartzPrms.remainderText
        quartz.notificationIDs = quartzPrms.notificationIDs.joined(separator: ", ")
        
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
            
            //add
            quartz.weekDays = quartzPrms.weekDays.joined(separator: ",")
            quartz.isRemainderOn = quartzPrms.isRemainderOn
            quartz.remainderText = quartzPrms.remainderText
            quartz.notificationIDs = quartzPrms.notificationIDs.joined(separator: ",")
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
    
    
    func scheduleNotification(prms: QuartzPrms)async throws -> [String] {
        let content = UNMutableNotificationContent()
        content.title = prms.quartzName
        content.subtitle = prms.remainderText
        content.sound = UNNotificationSound.default
        
        //IDs
        var notificationIds:[String] = []
        let calendar = Calendar.current
        let weekdaySymbols:[String] = calendar.weekdaySymbols
        
        for weekDay in prms.weekDays {
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: prms.startTime)
            let min = calendar.component(.minute, from: prms.startTime)
            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekDay
            } ?? -1
            if day != -1 {
                var components = DateComponents()
                components.weekday = day + 1
                components.hour = hour
                components.minute = min
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                try await UNUserNotificationCenter.current().add(request)
                notificationIds.append(id)
            }
        }
        return notificationIds
    }
    
    func requestNotificationAccess(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert]) { status, _ in
            DispatchQueue.main.sync {
                self.notificationAccess = status
            }
        }
    }
}

