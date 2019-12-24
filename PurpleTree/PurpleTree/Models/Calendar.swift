//
//  Calendar.swift
//  Purpletree
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 purpletree. All rights reserved.
//

import EventKit

func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: @escaping ((_ id: String?, _ error: NSError?) -> Void)) {
    let eventStore = EKEventStore()

    eventStore.requestAccess(to: .event) { (granted, error) in
        if (granted) && (error == nil) {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.notes = description
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                print("added")
                completion(event.eventIdentifier, nil)
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

func deleteEventfromCalendar(id: String) {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) {(granted, error) in
        if !granted { return }
        let eventToRemove = eventStore.event(withIdentifier: id)
        if eventToRemove != nil {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent, commit: true)
                print("removed")
            } catch {
                print(error)
            }
        } else {
            print("nothing to remove")
        }
    }
}
