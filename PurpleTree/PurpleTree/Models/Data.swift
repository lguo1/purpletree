//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

final class UserData: ObservableObject {
    @Published var events = load("events.json") ?? [Event]()
    init() {
        self.get("https://ppe.sccs.swarthmore.edu/")
    }
    func get(_ urlString: String) -> Void {
        request(urlString) {
        (events, error) in
            if let events = events {
                save("events.json", events: events)
                DispatchQueue.main.async{
                    self.events = events
                }
                for event in self.events {
                    DispatchQueue.main.async{
                        event.loader.interest = UserDefaults.standard.bool(forKey: event.id)
                    }
                }
            }
        }
    }
}


func save(_ filename: String, events: [Event]) -> Void {
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

func load(_ filename: String) -> [Event]? {
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
        return try decoder.decode([Event].self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \([Event].self):\n\(error)")
        return nil
    }
}

