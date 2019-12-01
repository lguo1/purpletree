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
    @Published var events = loadFromDownloads("userData.json") ?? [Event]()
    private var received  = [Event]()
    static var shared = UserData()
    init() {
        print(self.events.count)
        requestUpdate("http://localhost:5050/update/") {
            (update, error) in
            if let update = update {
                let display = update[0]
                for id in display {
                        print("Update event \(id)")
                        requestEvent("http://localhost:5050/event/\(id)/") {
                            (event, error) in
                            if let event = event {
                                self.received.append(event)
                            }
                            DispatchQueue.main.async {
                                saveDownloads("userData.json", events: self.received)
                                self.display = display
                                self.events = self.received
                        }
                    }
                }
            }
        }
    }
}

func saveDownloads(_ filename: String, events: [Event]) -> Void {
    print(events.count)
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    let jsonEncoder = JSONEncoder()
    do {
        let data = try jsonEncoder.encode(events)
        try data.write(to: fileURL)
    }
    catch {
        fatalError("Couldn't save \(filename):\n\(error)")
    }
}

func loadFromDownloads(_ filename: String) -> [Event]? {
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
        return try decoder.decode(Array<Event>.self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \(Array<Event>.self):\n\(error)")
        return nil
    }
}
