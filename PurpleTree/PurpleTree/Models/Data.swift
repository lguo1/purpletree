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
    static var shared = UserData()
    init() {
        requestUpdate("http://localhost:5050/update/") {
            (update, error) in
            if let update = update {
                self.display = update[0]
                for id in self.display {
                    requestEvent("http://localhost:5050/event/\(id)/") {
                        (event, error) in
                        if let event = event {
                           DispatchQueue.main.async {
                                self.events.append(event)
                            }
                        }
                    }
                }
            }
        }
    }
}
