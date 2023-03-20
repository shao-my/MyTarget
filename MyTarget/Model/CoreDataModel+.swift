//
//  CoreDataModel+.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/16.
//

import SwiftUI
import CoreData

class CoreDataModel: ObservableObject {
    @Published var quartzs: [Quartz] = []
    @Published var dayBooks: [DayBook] = []
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MyTarget")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.fetchQuartz()
                self.fetchDayBook()
                var shouldFetchDayBookAgain = false
                self.quartzs.forEach { quartz in
                    //判断符合时间
                    if (quartz.startDay! <= getStringForYYYYMMDD() && (quartz.endDay ?? "2999-12-31" >= getStringForYYYYMMDD()) )
                    {
                        var notInsertDayBook = false
                        //循环今天已有的dayBook数据，判断是否需要自动插入
                        self.dayBooks.forEach{ book in
                            if (book.quartzId == quartz.id){
                                notInsertDayBook = true
                            }
                        }
                        if !notInsertDayBook {
                            self.addDayBook(dayBookPrms: QuartzPrms.newPrmsByQuartz(quartz: quartz))
                            shouldFetchDayBookAgain = true
                        }
                    }
                }
                
                if shouldFetchDayBookAgain {
                    self.fetchDayBook()
                }
                let  path1 = NSHomeDirectory();
                print("path1:%@", path1);
                print("CoreData init success")
            }
        }
    }
    
    func fetchQuartz() {
        let request = NSFetchRequest<Quartz>(entityName: "Quartz")
        // request.predicate =   NSPredicate(format: "dayTime = %@", Date() as CVarArg)
        do {
            quartzs = try container.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addQuartz(id: UUID = UUID(),
                   quartzName: String,
                   quartzType: String,
                   quartzTimes: Int16,
                   quartzWay: String,
                   quartzIcon: String,
                   quartzColor: String,
                   startDay: String,
                   endDay: String,
                   startTime: String,
                   endTime: String)
    {
        let quartz = Quartz(context: container.viewContext)
        quartz.id = id
        quartz.quartzName = quartzName
        quartz.quartzType = quartzType
        quartz.quartzTimes = quartzTimes
        quartz.quartzWay = quartzWay
        quartz.quartzIcon = quartzIcon
        quartz.quartzColor = quartzColor
        quartz.startDay = startDay
        quartz.endDay = endDay
        quartz.startTime = startTime
        quartz.endTime = endTime
        saveQuartz()
    }
    
    /*func updateDayBook(newDayBook: DayBook) {
     var dayBook = DayBook(context: container.viewContext)
     dayBook = newDayBook
     saveDayBook()
     }*/
    
    func addQuartz(quartzPrms: QuartzPrms) {
        print("quartzName123:%@", quartzPrms.quartzName)
        let quartz = Quartz(context: container.viewContext)
        
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
        
        /* quartz.startDay = getStringForYYYYMMDD(dateTime: quartzPrms.startDay)
         quartz.endDay =  getStringForYYYYMMDD(dateTime: quartzPrms.endDay)
         quartz.startTime =  getStringForHHmm(dateTime: quartzPrms.startTime)
         quartz.endTime =  getStringForHHmm(dateTime: quartzPrms.endTime)*/
        saveQuartz()
        
        //新增Quartz时自动插入一条DayBook信息,避免当天维护任务无法刷新页面
        let dayBook = DayBook(context: container.viewContext)
        dayBook.id = UUID()
        dayBook.quartzId = quartzPrms.id
        dayBook.quartzName = quartzPrms.quartzName
        dayBook.dayTime =  quartzPrms.startDay
        //dayBook.dayTime = getStringForYYYYMMDD(dateTime: quartzPrms.startDay)
        dayBook.isCompleted = false
        dayBook.quartzType = quartzPrms.quartzType
        dayBook.quartzIcon = quartzPrms.quartzIcon
        dayBook.quartzColor = quartzPrms.quartzColor
        dayBook.quartzTimes =  Int16((quartzPrms.quartzTimes as NSString).intValue)
        dayBook.completedTimes = .zero
        dayBook.quartzWay = quartzPrms.quartzWay
        dayBook.startTime = quartzPrms.startTime
        dayBook.endTime = quartzPrms.endTime
        //dayBook.startTime = getStringForHHmm(dateTime: quartzPrms.startTime)
        //dayBook.endTime = getStringForHHmm(dateTime: quartzPrms.endTime)
        saveDayBook()
    }
    
    func deleteQuartz(quartz: Quartz) {
        container.viewContext.delete(quartz)
        saveQuartz()
    }
    
    
    
    func saveQuartz() {
        do {
            try container.viewContext.save()
            fetchQuartz()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func fetchDayBook() {
        let request = NSFetchRequest<DayBook>(entityName: "DayBook")
        request.predicate =   NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date()))
        do {
            dayBooks = try container.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    func addDayBook(id: UUID = UUID(),
                    quartzId: UUID,
                    quartzName: String,
                    dayTime: String,
                    isCompleted: Bool,
                    quartzType: String,
                    quartzIcon: String,
                    quartzColor: String,
                    quartzTimes: Int16,
                    completedTimes: Int16,
                    quartzWay: String,
                    startTime: String,
                    endTime: String)
    {
        let dayBook = DayBook(context: container.viewContext)
        dayBook.id = id
        dayBook.quartzId = quartzId
        dayBook.quartzName = quartzName
        dayBook.dayTime = dayTime
        dayBook.isCompleted = isCompleted
        dayBook.quartzType = quartzType
        dayBook.quartzIcon = quartzIcon
        dayBook.quartzColor = quartzColor
        dayBook.quartzTimes = quartzTimes
        dayBook.completedTimes = completedTimes
        dayBook.quartzWay = quartzWay
        dayBook.startTime = startTime
        dayBook.endTime = endTime
        saveDayBook()
    }
    
    /*func updateDayBook(newDayBook: DayBook) {
     var dayBook = DayBook(context: container.viewContext)
     dayBook = newDayBook
     saveDayBook()
     }*/
    
    func addDayBook(dayBookPrms: QuartzPrms) {
        let dayBook = DayBook(context: container.viewContext)
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
        dayBook.startTime = dayBookPrms.startTime
        dayBook.endTime =   dayBookPrms.endTime
        // dayBook.startTime =  getStringForHHmm(dateTime: dayBookPrms.startTime)
        // dayBook.endTime =  getStringForHHmm(dateTime: dayBookPrms.endTime)
        saveDayBook()
    }
    
    
    func deleteDayBook(dayBook: DayBook) {
        container.viewContext.delete(dayBook)
        saveDayBook()
    }
    
    func updateDayBook(dayBook: DayBook) {
        dayBook.isCompleted.toggle()
        do {
            try container.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
         
    }
    
    func saveDayBook() {
        do {
            try container.viewContext.save()
            fetchDayBook()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static let dayBookExamples = [
        DayBook.init()
    ]
    
}




