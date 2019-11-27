//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

final class UserData: ObservableObject {
    @Published var events: [Event]?
    static var shared = UserData()
    init() {
        request("http://localhost:5050/") {
        (EventData, error) in
            if let EventData = EventData {
                for event in EventData {
                    requestImage("http://localhost:5050/", imageName: event.imageName) {
                        (image, error) in
                        if let image = image {
                            self.saveImage(imageName: event.imageName, image: image)
                            DispatchQueue.main.async {
                                event.loader.image = image
                            }
                        } else {
                            print("error getting image")
                        }
                    }
                }
                DispatchQueue.main.async{
                    self.events = EventData
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
        if let data = image.jpegData(compressionQuality:  1.0),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("image saved")
            } catch {
                print("error saving image:", error)
            }
        }
    }
}
