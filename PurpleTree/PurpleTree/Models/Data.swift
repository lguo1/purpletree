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

