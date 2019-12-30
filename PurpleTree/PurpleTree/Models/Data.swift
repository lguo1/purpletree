//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

final class UserData: ObservableObject {
    var updates = [String]()
    @Published var events = Array(load("events.json")!.values)
    init() {
        self.get("https://ppe.sccs.swarthmore.edu/")
    }
    func get(_ urlString: String) -> Void {
        request(urlString) {
        (events, error) in
            if let events = events {
                let saved = load("events.json") ?? [String:Event]()
                self.updates = checkUpdate(saved: saved, new: events)
                save("events.json", events: events)
                for event in self.events {
                    event.loader.interest = UserDefaults.standard.bool(forKey: event.id)
                    if self.updates.contains(event.id) && event.loader.interest {
                        editEvent(event: event, ekid: UserDefaults.standard.string(forKey:"ek"+event.id)!) { (ekid, error) in
                            if let ekid = ekid {
                                UserDefaults.standard.set(ekid, forKey: "ek"+event.id)
                            }
                        }
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

func load(_ filename: String) -> [String: Event]? {
    let data: Data
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        print("Cound't find \(filename)")
        return nil
    }
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        print("Couldn't load \(filename):\n\(error)")
        return nil
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([String: Event].self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \([String: Event].self):\n\(error)")
        return nil
    }
}

