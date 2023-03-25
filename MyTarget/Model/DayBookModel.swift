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
}

        
