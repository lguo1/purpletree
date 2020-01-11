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

func scheduleNotification(id: String, title: String, body: String, start: String) {
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
    let uuid = UUID().uuidString
    UserDefaults.standard.set(uuid, forKey: "uu"+id)
    let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
    center.add(request)
    print("Scheduled notification with \(id)")
}

func removeNotification(id: String) {
    guard let uuid = UserDefaults.standard.string(forKey:"uu"+id) else {
        print("No notification to remove")
        return
    }
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [uuid])
    print("Removed notification with \(id)")
}
