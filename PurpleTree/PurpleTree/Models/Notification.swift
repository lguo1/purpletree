//
//  Notification.swift
//  Purpletree
//
//  Created by apple on 2020/1/7.
//  Copyright © 2020 purpletree. All rights reserved.
//

import UserNotifications

func requestNotification() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        if granted {
            print("Notification allowed")
        }
    }
}

func scheduleNotification(title: String, body: String, start: String) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let startDate = formatter.date(from: start)!
    let notificationDate = Calendar.current.date(byAdding: DateComponents(minute: -5), to: startDate)
    let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: notificationDate!)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    print("Notification of \(title) scheduled")
}
