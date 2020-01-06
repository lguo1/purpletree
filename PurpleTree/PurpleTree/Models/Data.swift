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
    var baseUrlString = "http://localhost:5050/"
    var updates = [String]()
    var overviews = loadOverviews()
    @Published var prefersCalendar = UserDefaults.standard.bool(forKey: "PrefersCalendar") {
        didSet { UserDefaults.standard.set(prefersCalendar, forKey: "PrefersCalendar")
        }
    }
    @Published var sortBy = SortBy.all
    @Published var events = Array(loadEvents().values)
    @Published var created = false
    init() {
        self.get()
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
    func get() -> Void {
        getEvent(self.baseUrlString) {
        (events, error) in
            if let events = events {
                self.checkUpdates(new: events)
                self.saveEvents()
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
    func saveOverviews() -> Void {
        let filename = "overviews.json"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(self.overviews)
            try data.write(to: fileURL)
        }
        catch {
            fatalError("Couldn't save \(filename):\n\(error)")
        }
    }
    
    func saveEvents() -> Void {
        let filename = "events.json"
        var toSave = [String: Event]()
        for event in self.events {
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
    
    func checkUpdates(new: [Event]) {
        let saved = loadEvents()
        for newEvent in new {
            if let savedEvent = saved[newEvent.id] {
                if savedEvent != newEvent {
                    updates.append(newEvent.id)
                }
            } else {
                updates.append(newEvent.id)
            }
        }
    }
}

func loadEvents() -> [String: Event] {
    let filename = "events.json"
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

func loadOverviews() -> [String: String] {
    let filename = "overviews.json"
    let data: Data
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        print("Cound't find \(filename)")
        return [String: String]()
    }
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        print("Couldn't load \(filename):\n\(error)")
        return [String: String]()
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([String: String].self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \([String: Event].self):\n\(error)")
        return [String: String]()
    }
}
