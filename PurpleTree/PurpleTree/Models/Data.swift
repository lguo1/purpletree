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
                for event in EventData {
                    UserDefaults.standard.set(false, forKey: event.id)
                    requestImageData("http://localhost:5050/", imageName: event.imageHomeName) {
                        (data, error) in
                        if let data = data {
                            self.saveImageData(imageName: event.imageHomeName, data: data)
                            DispatchQueue.main.async {
                                event.homeLoader.didChange.send(data)
                            }
                        } else {
                            print("error getting \(event.imageHomeName) from internet")
                        }
                    }
                    requestImageData("http://localhost:5050/", imageName: event.imageDetailName) {
                        (data, error) in
                        if let data = data {
                            self.saveImageData(imageName: event.imageDetailName, data: data)
                            DispatchQueue.main.async {
                                event.detailLoader.didChange.send(data)
                            }
                        } else {
                            print("error getting \(event.imageDetailName) from internet")
                        }
                    }
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
