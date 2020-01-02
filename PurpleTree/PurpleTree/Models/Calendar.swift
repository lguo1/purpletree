//
//  Calendar.swift
//  Purpletree
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 purpletree. All rights reserved.
//

import EventKit

func addToCalendar(id: String, speaker: String, start: String, end: String, description: String) {
    let ekid = UserDefaults.standard.string(forKey:"ek"+id) ?? String()
    let eventStore = EKEventStore()
    let ekEvent = eventStore.event(withIdentifier: ekid)
    eventStore.requestAccess(to: .event) { (granted, error) in
        if !granted { return }
        if let ekEvent = ekEvent {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            ekEvent.title = speaker
            ekEvent.startDate = formatter.date(from: start)
            ekEvent.endDate = formatter.date(from: end)
            ekEvent.notes = description
            do {
                try eventStore.save(ekEvent, span: .thisEvent)
                UserDefaults.standard.set(ekEvent.eventIdentifier, forKey: "ek"+id)
                print("added \(ekEvent.eventIdentifier ?? "none") again")
            } catch {
                print(error)
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let ekEvent = EKEvent(eventStore: eventStore)
            ekEvent.title = speaker
            ekEvent.startDate = formatter.date(from: start)
            ekEvent.endDate = formatter.date(from: end)
            ekEvent.notes = description
            ekEvent.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(ekEvent, span: .thisEvent)
                UserDefaults.standard.set(ekEvent.eventIdentifier, forKey: "ek"+id)
                print("added \(ekEvent.eventIdentifier ?? "none")")
            } catch {
                print(error)
            }
        }
    }
}
func removeFromCalendar(id: String) {
    let ekid = UserDefaults.standard.string(forKey:"ek"+id)!
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) {(granted, error) in
        if !granted { return }
        let ekEvent = eventStore.event(withIdentifier: ekid)
        if let ekEvent = ekEvent {
            do {
                try eventStore.remove(ekEvent, span: .thisEvent, commit: true)
                UserDefaults.standard.removeObject(forKey: "ek"+id)
            } catch {
                print(error)
            }
        } else {
            print("nothing to remove")
        }
    }
}

