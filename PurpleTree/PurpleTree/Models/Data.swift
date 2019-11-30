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
    func saveImageData(imageName: String, data: Data) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("error removing \(imageName)", error)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch {
            print("error saving \(imageName)", error)
        }
    }
}
