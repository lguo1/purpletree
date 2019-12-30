//
//  Calendar.swift
//  Purpletree
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 purpletree. All rights reserved.
//

import EventKit

func addEventToCalendar(event: Event) {
    let ekid = UserDefaults.standard.string(forKey:"ek"+event.id)
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { (granted, error) in
        if !granted { return }
        if let ekid = ekid {
            let formatter = DateFormatter()
            let ekEvent = eventStore.event(withIdentifier: ekid)!
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            ekEvent.title = event.speaker
            ekEvent.startDate = formatter.date(from: event.fullStart)
            ekEvent.endDate = formatter.date(from: event.fullEnd)
            ekEvent.notes = event.description
            do {
                try eventStore.save(ekEvent, span: .thisEvent)
                print("Added again")
                UserDefaults.standard.set(ekid, forKey: "ek"+event.id)
            } catch {
                print(error)
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let ekEvent = EKEvent(eventStore: eventStore)
            ekEvent.title = event.speaker
            ekEvent.startDate = formatter.date(from: event.fullStart)
            ekEvent.endDate = formatter.date(from: event.fullEnd)
            ekEvent.notes = event.description
            ekEvent.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(ekEvent, span: .thisEvent)
                print("added")
            } catch {
                print(error)
            }
        }
    }
}

func removeEventFromCalendar(event: Event) {
    let ekid = UserDefaults.standard.string(forKey:"ek"+event.id)!
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) {(granted, error) in
        if !granted { return }
        let ekEvent = eventStore.event(withIdentifier: ekid)
        if let ekEvent = ekEvent {
            do {
                try eventStore.remove(ekEvent, span: .thisEvent, commit: true)
                print("removed")
            } catch {
                print(error)
            }
        } else {
            print("nothing to remove")
        }
    }
}

