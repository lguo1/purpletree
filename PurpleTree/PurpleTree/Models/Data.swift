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
                    requestImage("http://localhost:5050/", imageName: event.imageHomeName) {
                        (image, error) in
                        if let image = image {
                            self.saveImage(imageName: event.imageHomeName, image: image)
                            DispatchQueue.main.async {
                                event.homeLoader.image = image
                            }
                        } else {
                            print("error getting \(event.imageHomeName) from internet")
                        }
                    }
                    requestImage("http://localhost:5050/", imageName: event.imageDetailName) {
                        (image, error) in
                        if let image = image {
                            self.saveImage(imageName: event.imageDetailName, image: image)
                            DispatchQueue.main.async {
                                event.detailLoader.didChange.send(image)
                            }
                        } else {
                            print("error getting \(event.imageHomeName) from internet")
                        }
                    }
                }
            }
            else {
                self.events = [Event]()
            }
        }
    }
    func saveImage(imageName: String, image: UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        if let data = image.pngData() {
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
}
