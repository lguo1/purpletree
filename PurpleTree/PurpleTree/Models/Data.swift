//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

final class UserData: ObservableObject {
    @Published var display = UserDefaults.standard.string(forKey: "display") ?? String() {
        didSet {
            UserDefaults.standard.set(display, forKey: "display")
        }
    }
    @Published var events = [Event]()
    private var received  = loadFromDownloads("userData.json") ?? [String: Event]()
    init() {
        requestUpdate("http://localhost:5050/update/") {
            (update, error) in
            if let update = update {
                let display = update[0]
                let modify = update[1]
                for id in display {
                    if modify.contains(id) {
                        requestEvent("http://localhost:5050/event/\(id)/") {
                            (event, error) in
                            if let event = event {
                                self.received[event.id] = event
                                DispatchQueue.main.async {
                                    print("Modify event \(id)")
                                    self.events.append(event)
                                }
                            }
                        }
                    } else if let event = self.received[String(id)] {
                        DispatchQueue.main.async {
                            print("Load event \(id)")
                            self.events.append(event)
                        }
                    } else {
                        requestEvent("http://localhost:5050/event/\(id)/") {
                            (event, error) in
                            if let event = event {
                                self.received[event.id] = event
                                DispatchQueue.main.async {
                                    print("Update event \(id)")
                                    self.events.append(event)
                                }
                            }
                        }
                    }
                }
                saveDownloads("userData.json", eventData: self.received)
            }
        }
    }
}

func saveDownloads(_ filename: String, eventData: [String: Event]) -> Void {
    print(eventData.count)
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    let jsonEncoder = JSONEncoder()
    do {
        let data = try jsonEncoder.encode(eventData)
        try data.write(to: fileURL)
    }
    catch {
        fatalError("Couldn't save \(filename):\n\(error)")
    }
}

func loadFromDownloads(_ filename: String) -> [String: Event]? {
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

