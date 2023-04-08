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

func getYearMonthDayWeek() -> String {
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
    let array = ["周日","周一","周二","周三","周四","周五","周六"]
    //week = array[weekDay]
    let weekDay = comps.weekday! - 1
    
    time =  "\(comps.year!)年\(comps.month!)月\(comps.day!)日 " + array[weekDay]
    return time;
}

func getYearMonthDayWeekByPrms(date: Date = Date(),prms: String) -> Int {
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var comps: DateComponents = DateComponents()
    comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: date)
    
    if prms == "Year" {
        return comps.year!
    }
    if prms == "Month" {
        return comps.month!
    }
    if prms == "Day" {
        return comps.day!
    }
    if prms == "Week" {
        return comps.weekday! - 1
    }
    
    return 0;
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

func getYYYYMM (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy年MM月"
    return formatter.string(from: dateTime)
}

func getStringForYYYYMM (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM"
    return formatter.string(from: dateTime)
}

func getStringForHH (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "HH"
    return formatter.string(from: dateTime)
}

func getStringForYYYYMMDD (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: dateTime)
}

func getStringForYYYYMMDDMMSS (dateTime: Date = Date()) -> String {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: dateTime)
}

func getDateForYYYYMMDD (dateTime: String) -> Date {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: dateTime) ?? Date()
}

func getDateForYYYYMMDDHHMM (dateTime: String) -> Date {
    let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm"
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

func getHoursInDay(date: Date = Date()) -> [Date] {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: date)
    var hours: [Date] = []
    for index in  0..<24 {
        if let date = calendar.date(byAdding: .hour,value: index, to: startOfDay){ 
            hours.append(date)
        }
    } 
    return hours
}

func getTimeDifference(time1: Date, time2: Date) -> String {
   /* let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    return formatter.string(from: time1, to: time2)!*/
    
    let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: time1, to: time2)
    let seconds = dateComponents.second
    let hours = seconds! / 3600
    let minutes = (seconds! - hours * 3600) / 60
    return "\(hours) 小时 \(minutes) 分钟"
}

func getToDayTimeDifference(time1: Date, time2: Date) -> String {
   /* let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    return formatter.string(from: time1, to: time2)!*/
    
    let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: getTodaySameHHMM(date: time1), to: time2)
    var seconds = dateComponents.second
    var hours = seconds! / 3600
    var minutes = (seconds! - hours * 3600) / 60
    var str = "\(hours) 小时 \(minutes) 分钟"
    if seconds! < 0 {
        seconds = 0 - seconds!
          hours = seconds! / 3600
          minutes = (seconds! - hours * 3600) / 60
        str = "提前 \(hours) 小时 \(minutes) 分钟"
    }
    return str
}

func getTodaySameHHMM(date: Date) -> Date {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: Date())
    let minutes = calendar.component(.minute, from: date)
    let hours = calendar.component(.hour, from: date)
    let now = Calendar.current.date(byAdding: .minute, value: hours * 60 + minutes, to: startOfDay)!
    return now
}

extension Date {
    func dateToString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

}
