//
//  DateFormatTools.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/3/13.
//

import SwiftUI

func getMonthDayWeek() -> String {
    var time:String = "" //返回的时间
 
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var comps: DateComponents = DateComponents()
    comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
 
    /*timers.append(comps.year! % 2000)  // 年 ，后2位数
    timers.append(comps.month!)            // 月
    timers.append(comps.day!)                // 日
    timers.append(comps.hour!)               // 小时
    timers.append(comps.minute!)            // 分钟
    timers.append(comps.second!)            // 秒
    timers.append(comps.weekday! - 1)      //星期*/
    let array = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
    //week = array[weekDay]
    let weekDay = comps.weekday! - 1
    
    time =  "\(comps.month!)月\(comps.day!)日 " + array[weekDay]
    return time;
}


func getYearMonthDay() -> String {
    var time:String = "" //返回的时间
 
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var comps: DateComponents = DateComponents()
    comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
 
    
    time =  "\(comps.year!)\(comps.month!)\(comps.day!)"
    
    
    time = String(format: "%04d%02d%02d", comps.year!, comps.month!, comps.day!)
    
    return time;

    /*
     let formatter = DateFormatter()
     formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
     let date = formatter.date(from: string)
     
     let formatStyle = Date.FormatStyle()
         .year(.defaultDigits)
         .month(.twoDigits)
         .day(.twoDigits)
         .hour()
         .minute()
         .second()
         .timeZone()
     
     let date = try formatStyle.parse(string)
     */
}


func getStringForYYYYMMDD (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: dateTime)
}

func getDateForYYYYMMDD (dateTime: String) -> Date {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: dateTime) ?? Date()
}
 

func getStringForHHmm (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm"
    return formatter.string(from: dateTime)
}

func string2Date(_ string:String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") -> Date {
    let formatter = DateFormatter()
    formatter.locale = Locale.init(identifier: "zh_CN")
    formatter.dateFormat = dateFormat
    let date = formatter.date(from: string)
    return date!
}
