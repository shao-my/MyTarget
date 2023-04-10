//
//  DayBookModel.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/24.
//

import SwiftUI
import CoreData

class DayBookModel: ObservableObject {
    @Published var id: UUID = UUID()
    @Published var quartzId: UUID = UUID()
    @Published var quartzName: String =  ""
    @Published var dayTime: String =  ""
    @Published var isCompleted: Bool  = false
    @Published var quartzType: String  = ""
    @Published var quartzIcon: String  = SFSymbol.def.rawValue
    @Published var quartzColor: String  = "gray"
    @Published var quartzTimes: Int16  = 0
    @Published var completedTimes: Int16  = 0
    @Published var quartzWay: String  = ""
    @Published var startTime: Date  = Date()
    @Published var endTime: Date = Date()
    @Published var finishedTime: Date  = Date()
    
    @Published var dayBookList:  [DayBook] = []
    
    func fetchDayBookForDay(context: NSManagedObjectContext,date: Date = Date()) -> [DayBook] {
        //查询当天的DayBook
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        requestDayBook.predicate =   NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: date))
        do {
            dayBooks = try context.fetch(requestDayBook)
        } catch let error {
            print(error.localizedDescription)
        }
        return dayBooks
    }
    
    func fetchDayBookForYear(context: NSManagedObjectContext,quartzId: UUID,date: Date = Date()) -> [DayBook] {
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        let lastYearDay = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        requestDayBook.predicate =   NSPredicate(format: "dayTime >= %@ and dayTime <= %@ and quartzId = %@", getStringForYYYYMM(dateTime: lastYearDay!),getStringForYYYYMMDD(dateTime: Date()), quartzId as CVarArg)
        do {
            dayBooks = try context.fetch(requestDayBook)
        } catch let error {
            print(error.localizedDescription)
        }
        return dayBooks
    }
    
    
    func initDayBooks(context: NSManagedObjectContext){ 
        //查询有效Quartz
        var quartzs: [Quartz] = []
        let requestQuartz = NSFetchRequest<Quartz>(entityName: "Quartz")
        requestQuartz.predicate =  NSPredicate(format: "status = %@", "1")
        do {
            quartzs = try context.fetch(requestQuartz)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //查询当天的DayBook
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        requestDayBook.predicate =   NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date()))
        do {
            dayBooks = try context.fetch(requestDayBook)
        } catch let error {
            print(error.localizedDescription)
        }
        
        quartzs.forEach { quartz in
            //判断符合时间
            if  (quartz.startDay! <= getStringForYYYYMMDD() && (quartz.endDay ?? "2999-12-31" >= getStringForYYYYMMDD() || quartz.endDay == ""))
            {
                var notInsertDayBook = false
                //循环今天已有的dayBook数据，判断是否需要自动插入
                dayBooks.forEach{ book in
                    if (book.quartzId == quartz.id){
                        notInsertDayBook = true
                    }
                }
                if !notInsertDayBook {
                   // self.addDayBook(dayBookPrms: QuartzPrms.newPrmsByQuartz(quartz: quartz))
                        let dayBookPrms =  QuartzPrms.newPrmsByQuartz(quartz: quartz)
                     
                        let dayBook = DayBook(context: context)
                        dayBook.id = UUID()
                        dayBook.quartzId = dayBookPrms.id
                        dayBook.quartzName = dayBookPrms.quartzName
                        // dayBook.dayTime =  getStringForYYYYMMDD(dateTime: dayBookPrms.startDay)
                        dayBook.dayTime =  dayBookPrms.dayTime
                        dayBook.isCompleted = false
                        dayBook.quartzType = dayBookPrms.quartzType
                        dayBook.quartzIcon = dayBookPrms.quartzIcon
                        dayBook.quartzColor = dayBookPrms.quartzColor
                        dayBook.quartzTimes =  Int16((dayBookPrms.quartzTimes as NSString).intValue)
                        dayBook.completedTimes = .zero
                        dayBook.quartzWay = dayBookPrms.quartzWay
                        dayBook.startTime = getTodaySameHHMM(date: dayBookPrms.startTime)
                        dayBook.endTime = getTodaySameHHMM(date: dayBookPrms.endTime)
                        // dayBook.startTime =  getStringForHHmm(dateTime: dayBookPrms.startTime)
                        // dayBook.endTime =  getStringForHHmm(dateTime: dayBookPrms.endTime)
                     
                    do {
                        try context.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            }
        }
    }
}

        
