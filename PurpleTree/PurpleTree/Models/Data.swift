//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//

import Combine
import SwiftUI

func request(_ location: String, completionHandler: @escaping ([Event]?, Error?) -> Void) -> Void {
    
    guard let url = URL(string: location) else {
        print("Cannot create URL")
        return
    }
    let task = URLSession.shared.dataTask(with: url) {
       (data, response, error) in
       guard let data = data else {
            print("No data")
            completionHandler(nil, error)
            return
       }
       let decoder = JSONDecoder()
       do {
        let eventData = try decoder.decode(Array<Event>.self, from: data)
            print("Networking succeeded")
            for event in eventData {
                request_image(location, imageName: event.imageName)
            }
            completionHandler(eventData, nil)
       } catch {
            print("Decoding failed")
            completionHandler(nil, error)
       }
   }
   task.resume()
}

func request_image(_ location: String, imageName: String) -> Void {
    
    guard let url = URL(string: location+"img/"+imageName+"/") else {
        print("Cannot create URL")
        return
    }
    let task = URLSession.shared.dataTask(with: url) {
    (data, response, error) in
    guard let data = data else {
         print("No data")
         return
    }
        save_image(imageName: imageName, image: UIImage(data: data)!)
    }
    task.resume()
}


func save_image(imageName: String, image: UIImage) {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(imageName)
    if let data = image.jpegData(compressionQuality:  1.0),
      !FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            // writes the image data to disk
            try data.write(to: fileURL)
            print("file saved")
        } catch {
            print("error saving file:", error)
        }
    }
}


final class UserData: ObservableObject {
    @Published var events: [Event]?
    init() {
        request("http://localhost:5050/") {
        (EventData, error) in
            if let EventData = EventData {
                self.events = EventData
            }
            else {
                self.events = [Event]()
            }
        }
    }
}

final class Interest {
    var id: String
    var isInterested: Bool {
        get {
            UserDefaults.standard.value(forKey: self.id) as! Bool
        }
        set(new) {
            UserDefaults.standard.set(new, forKey: self.id)
        }
    }
    init(id: String) {
        self.id = id
        self.isInterested = false
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(verbatim: name))
    }

    static func loadImage(name: String) -> CGImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent(name)
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)!.cgImage
        } catch {
            print("Error loading image : \(error)")
            return nil
        }
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}
