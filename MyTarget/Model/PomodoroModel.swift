//
//  PomodoroModel.swift
//  MyTarget
//
//  Created by 邵明易 on 2023/4/11.
//

import SwiftUI
import CoreData
import WidgetKit

class PomodoroModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var progress: CGFloat = 1
    @Published var timerStringValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var isPaused: Bool = false
    @Published var addNewTimer: Bool = false
    
    @Published var hour: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isFinished: Bool = false
    
    @Published var quartzId: UUID = UUID()
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    func authorizeNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.alert,.badge]) { _, _ in
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.banner])
    }
    
    func startTime() {
        withAnimation(.easeInOut(duration: 0.25)){ isStarted = true }
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        totalSeconds = (hour * 3600) + (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
        addNewTimer = false
        addNotification()
    }
    
    func stopTimer() {
        withAnimation {
            isStarted = false
            hour = 0
            minutes = 0
            seconds = 0
            progress = 1
        }
        isPaused = false
        totalSeconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer(context: NSManagedObjectContext) {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        hour = totalSeconds / 3600
        minutes = (totalSeconds / 60) % 60
        seconds = (totalSeconds % 60)
        timerStringValue = "\(hour == 0 ? "" : "\(hour):")\(minutes >= 10 ? "\(minutes)":"0\(minutes)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)")"
        if hour == 0 && seconds == 0 && minutes == 0 {
            isStarted = false
            isFinished = true
            print("Finished")
            //同步更新任务状态，标志完成
            //查询当天的DayBook
            var dayBooks: [DayBook] = []
            let requestDayBook = NSFetchRequest<DayBook>(entityName: "DayBook")
            requestDayBook.predicate =   NSPredicate(format: "dayTime = %@ and quartzId = %@", getStringForYYYYMMDD(dateTime: Date()),quartzId as CVarArg)
            do {
                dayBooks = try context.fetch(requestDayBook)
            } catch let error {
                print(error.localizedDescription)
            }
             
            if dayBooks.count > 0 {
                let db = dayBooks[0]
                // db.isCompleted.toggle()
                db.isCompleted = true
                if db.isCompleted {
                    db.finishedTime = Date()
                    db.completedTimes = db.quartzTimes
                }else{
                    db.finishedTime = nil
                }
                //打卡，更新状态
                try?  context.save()
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        content.title = "MyTarger Timer"
        content.subtitle = "倒计时完成"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(totalSeconds), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}

