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
            completionHandler(eventData, nil)
       } catch {
            print("Decoding failed")
            completionHandler(nil, error)
       }
   }
   task.resume()
}

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

final class UserData: ObservableObject {
    @Published var events: [Event]?
    @Published var interests: [Int:Bool]?
    init() {
        request("http://localhost:5000/") {
        (EventData, error) in
            if let EventData = EventData {
                self.events = EventData
            }
            else {
                self.events = [Event]()
            }
        }
    }
    
    func modify() {
        for index in self.events!.indices {
            if let past = UserDefaults.standard.value(forKey: self.events![index].id) {
                self.events![index].interested = past as! Bool
            } else {
                UserDefaults.standard.set(self.events![index].interested, forKey: self.events![index].id)
            }
        }
    }
    
    func store(index: Int) {
        UserDefaults.standard.set(self.events![index].interested, forKey: self.events![index].id)
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

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}
