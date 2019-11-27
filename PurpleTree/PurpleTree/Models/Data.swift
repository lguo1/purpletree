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
    private var observerArray = [Observer]()
    init() {
        request("http://localhost:5050/") {
        (EventData, error) in
            if let EventData = EventData {
                for event in EventData {
                    requestImage("http://localhost:5050/", imageName: event.imageName) {
                        (Image, error) in
                        if Image != nil {
                            self.notify(event.id)
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
    func attachObserver(observer : Observer){
        observerArray.append(observer)
    }
    private func notify(_ id: String){
        var observerIndex: Int {
            return observerArray.firstIndex(where: { $0.id == id})!
        }
        observerArray[observerIndex].update()
    }
}

protocol Observer: class {
    var id: String { get }
    var updated: Bool { get }
    func update() -> Void
}

final class ImageObserver: Observer {
    private var subject: UserData
    var updated = false
    var id: String
    init(subject: UserData, id: String) {
        self.subject = subject
        self.id = id
        self.subject.attachObserver(observer: self)
    }
    func update() -> Void {
        updated = true
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


func saveImage(imageName: String, image: UIImage) {
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

func loadDefault() -> CGImage {
    guard
        let url = Bundle.main.url(forResource: "default", withExtension: "jpg"),
        let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
        let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    else {
        fatalError("Couldn't load image default.jpg from main bundle.")
    }
    return image
}


