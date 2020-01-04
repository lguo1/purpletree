//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

final class UserData: ObservableObject {
    static var shared = UserData()
    var updates = [String]()
    @Published var prefersCalendar = UserDefaults.standard.bool(forKey: "PrefersCalendar") {
        didSet { UserDefaults.standard.set(prefersCalendar, forKey: "PrefersCalendar")
        }
    }
    @Published var sortBy = SortBy.all
    @Published var events = Array(load("events.json").values)
    @Published var created = false
    init() {
        self.get("https://ppe.sccs.swarthmore.edu/")
    }
    enum SortBy: String, CaseIterable {
        case all = "All"
        case arts = "Arts"
        case economics = "Economics"
        case history = "History"
        case mathematics = "Mathematics"
        case philosophy = "Philosophy"
        case politics = "Politics"
        case science = "Science"
        case sociology = "Sociology"
        case technology = "Technology"
    }
    func get(_ urlString: String) -> Void {
        request(urlString) {
        (events, error) in
            if let events = events {
                let saved = load("events.json")
                self.updates = checkUpdate(saved: saved, new: events)
                save("events.json", events: events)
                for event in self.events {
                    if self.updates.contains(event.id) {
                        event.loader.changeInterest =  UserDefaults.standard.bool(forKey: event.id)
                    } else {
                        event.loader.interest = UserDefaults.standard.bool(forKey: event.id)
                    }
                }
                DispatchQueue.main.async{
                    self.events = events
                }
            }
        }
    }
}

func checkUpdate(saved: [String: Event], new: [Event]) -> [String] {
    var updates = [String]()
    for newEvent in new {
        if let savedEvent = saved[newEvent.id] {
            if savedEvent != newEvent {
                updates.append(newEvent.id)
            }
        } else {
            updates.append(newEvent.id)
        }
    }
    return updates
}

func save(_ filename: String, events: [Event]) -> Void {
    var toSave = [String: Event]()
    for event in events {
        toSave[event.id] = event
    }
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    let jsonEncoder = JSONEncoder()
    do {
        let data = try jsonEncoder.encode(toSave)
        try data.write(to: fileURL)
    }
    catch {
        fatalError("Couldn't save \(filename):\n\(error)")
    }
}

func load(_ filename: String) -> [String: Event] {
    let data: Data
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        print("Cound't find \(filename)")
        return [String: Event]()
    }
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        print("Couldn't load \(filename):\n\(error)")
        return [String: Event]()
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([String: Event].self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \([String: Event].self):\n\(error)")
        return [String: Event]()
    }
}

