//
//  Notification.swift
//  Purpletree
//
//  Created by apple on 2020/1/7.
//  Copyright © 2020 purpletree. All rights reserved.
//

import UserNotifications



func scheduleNotification(title: String, body: String) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    print("Notification scheduled")
}
