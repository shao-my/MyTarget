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
