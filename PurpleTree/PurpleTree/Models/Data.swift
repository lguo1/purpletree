//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

final class UserData: ObservableObject {
    var test = false
    @Published var events = [Event]()
    static var shared = UserData()
    init() {
        request("http://localhost:5050/") {
        (EventData, error) in
            if let EventData = EventData {
                DispatchQueue.main.async{
                    self.events = EventData
                }
            }
            else {
                self.events = [Event]()
            }
        }
    }
}
