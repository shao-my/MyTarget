//
//  Persistence.swift
//  CoreDataDemo
//
//  Created by 邵明易 on 2023/3/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
     

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MyTarget")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        let  path1 = NSHomeDirectory();
        print("path1:%@", path1);
        print("CoreData init success")
        let viewContext = container.viewContext
        
       container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
        //查询有效Quartz
        var quartzs: [Quartz] = []
        let requestQuartz = NSFetchRequest<Quartz>(entityName: "Quartz")
        requestQuartz.predicate =  NSPredicate(format: "status = %@", "1")
        do {
            quartzs = try viewContext.fetch(requestQuartz)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //查询当天的DayBook
        var dayBooks: [DayBook] = []
        let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
        requestDayBook.predicate =   NSPredicate(format: "dayTime = %@", getStringForYYYYMMDD(dateTime: Date()))
        do {
            dayBooks = try viewContext.fetch(requestDayBook)
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
                     
                        let dayBook = DayBook(context: viewContext)
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
                        try viewContext.save()
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
