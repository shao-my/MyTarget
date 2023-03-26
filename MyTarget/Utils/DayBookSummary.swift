//
//  DayBookSummary.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/16.
//

import SwiftUI

func getDayBookSummary(dayBooks: [DayBook] ,quartzType: String) -> String {
    var completedCount: Int = .zero,
        sumCount: Int = .zero
    
    for book in dayBooks {
        if book.quartzType == quartzType {
            if book.isCompleted == true {
                completedCount += 1
            }
            sumCount += 1
        }
    }
    //补0，默认两位数
    let completeCountStr = completedCount > 10 ? "\(completedCount)" : "0\(completedCount)"
    let sumCountStr = sumCount > 10 ? "\(sumCount)" : "0\(sumCount)"

    return "\(completeCountStr) / \(sumCountStr)"
}

func getDayBookPercent(dayBooks: [DayBook] ,quartzType: String) -> Double {
    var completedCount: Double = .zero,
        sumCount: Double = .zero
    
    for book in dayBooks {
        if book.quartzType == quartzType {
            if book.isCompleted == true {
                completedCount += 1.0
            }
            sumCount += 1.0
        }
    }
    return Double(completedCount/sumCount)
}


func getDayBookSumCount(dayBooks: [DayBook] ,quartzType: String) -> Int {
    var sumCount: Int = .zero
    
    for book in dayBooks {
        if book.quartzType == quartzType {
            if book.isCompleted == true {
                sumCount += 1
            }
        }
    }
    return sumCount
}

func getDayBookCompletedCount(dayBooks: [DayBook] ,quartzType: String) -> Int {
    var completedCount: Int = .zero
    
    for book in dayBooks {
        if book.quartzType == quartzType {
            if book.isCompleted == true {
                completedCount += 1
            }
        }
    }
    return completedCount
}

func getDayBookCompletedTime(dayBooks: [DayBook] ,quartzType: String) -> String {
    var completedSeconds: Int = .zero
    
    for book in dayBooks {
        if book.quartzType == quartzType {
            if book.isCompleted == true {
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([Calendar.Component.second], from:  book.startTime!, to: book.finishedTime!)
                completedSeconds += dateComponents.second!
            }
        }
    }
    
    let hours = completedSeconds / 3600
    let minutes = (completedSeconds - hours * 3600) / 60
    return "\(hours) 小时 \(minutes) 分钟"
}


func getDayBookCountDays(dayBooks: [DayBook] ,quartzType: String) -> Int {
    //var daysCount: Int = .zero
    var daysList: [String] = []
    
    for book in dayBooks {
        if book.quartzType == quartzType {
            if book.isCompleted == true {
                if(!daysList.contains(book.dayTime!)){
                    daysList.append(book.dayTime!)
                }
            }
        }
    }
    return daysList.count
}

