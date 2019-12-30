//
//  Calendar.swift
//  Purpletree
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 purpletree. All rights reserved.
//

import EventKit

func addEventToCalendar(event: Event, completion: @escaping ((_ ekid: String?, _ error: NSError?) -> Void)) {
    let eventStore = EKEventStore()

    eventStore.requestAccess(to: .event) { (granted, error) in
        if (granted) && (error == nil) {
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
                completion(ekEvent.eventIdentifier, nil)
            } catch {
                print(error)
                completion(nil, error as NSError)
            }
        } else {
            print("no access")
            completion(nil, error as NSError?)
        }
    }
}

func deleteEventfromCalendar(ekid: String) {
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
func editEvent(event: Event, ekid: String) {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { (granted, error) in
        if !granted { return }
        let ekEvent = eventStore.event(withIdentifier: ekid)
        if let ekEvent = ekEvent {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            ekEvent.title = event.speaker
            ekEvent.startDate = formatter.date(from: event.fullStart)
            ekEvent.endDate = formatter.date(from: event.fullEnd)
            ekEvent.notes = event.description
            do {
                try eventStore.save(ekEvent, span: .thisEvent)
                print("added")
            } catch {
                print(error)
            }
        } else {
            print("nothing to edit")
        }
    }
}
