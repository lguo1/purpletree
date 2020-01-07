//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

final class UserData: ObservableObject {
    //Unpublished variables
    static var shared = UserData()
    var tempEventData = [String: Event]()
    var tempOrganizerData = [String: Organizer]()
    var tempImageData = [String: [UIImage?]]()
    var endPoint = "http://localhost:5050/"
    //Settings
    @Published var sortBy = SortBy.all
    @Published var prefersCalendar = UserDefaults.standard.bool(forKey: "PrefersCalendar") {
        didSet {UserDefaults.standard.set(prefersCalendar, forKey: "PrefersCalendar")
        }
    }
    //Data
    @Published var organizerData = loadOrganizerData()
    @Published var eventData = loadEventData()
    @Published var imageData = [String: [UIImage?]]()
    @Published var sorted = [Event]()
    
    init() {
        sorted = Array(eventData.values).sorted(by: {
                if $0.decided == $1.decided {
                    return  $0.start < $1.start
                } else {
                    return $0.decided
                }
            })
        loadImageData()
        getData()
// needs to make sure sortby is all
    }
    
    func getData() -> Void {
        let textgroup = DispatchGroup()
        textgroup.enter()
        getEventData("\(self.endPoint)event/") { eventData in
            if let eventData = eventData {
                self.tempEventData = self.updateEvent(eventData)
                self.getImageData(outerGroup: textgroup)
            }
        }
        textgroup.enter()
        getOrganizerData("\(self.endPoint)organizer/") { organizerData in
            if let organizerData = organizerData {
                self.tempOrganizerData = self.updateOrganizer(organizerData)
                textgroup.leave()
            }
        }
        textgroup.notify(queue: .main) {
            self.saveData()
            self.eventData = self.tempEventData
            self.organizerData = self.tempOrganizerData
            self.imageData = self.tempImageData
            self.sorted = Array(self.eventData.values).sorted(by: {
                if $0.decided == $1.decided {
                    return  $0.start < $1.start
                } else {
                    return $0.decided
                }
            })
            print("Networking completes")
        }
    }
    
    func saveData() -> Void {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonEncoder = JSONEncoder()
        let organizerURL = documentsDirectory.appendingPathComponent("organizerData.json")
        let eventURL = documentsDirectory.appendingPathComponent("eventData.json")
        do {
            let data = try jsonEncoder.encode(self.tempOrganizerData)
            try data.write(to: organizerURL)
            print("Saved organizerData.json")
        }
        catch {
            print("Couldn't save organizerData.json")
        }
        do {
            let data = try jsonEncoder.encode(self.tempEventData)
            try data.write(to: eventURL)
            print("Saved eventData.json")
        }
        catch {
            print("Couldn't save eventData.json")
        }
    }
    
    func updateEvent(_ new: [String: Event]) -> [String: Event] {
        var output = new
        for data in output {
            if let saved = self.eventData[data.key]{
                output[data.key]!.interest = saved.interest
            }
        }
        return output
    }
    
    func updateOrganizer(_ new: [String: Organizer]) -> [String: Organizer] {
        var output = new
        for data in output {
            if let saved = self.organizerData[data.key]{
                output[data.key]!.subscribed = saved.subscribed
            }
        }
        return output
    }
    
    func loadImageData() -> Void {
        for data in eventData {
            var pair = [UIImage?]()
            pair.append(loadImage(data.value.imageNameHome))
            pair.append(loadImage(data.value.imageNameDetail))
            imageData[data.key] = pair
        }
    }
    
    func getImageData(outerGroup: DispatchGroup) -> Void {
        let innerGroup = DispatchGroup()
        for data in tempEventData {
            var pair = [UIImage?]()
            innerGroup.enter()
            if imageData[data.key] == nil {
                getImage("\(self.endPoint)", imageName: data.value.imageNameHome) { image in
                    pair.append(image)
                    getImage("\(self.endPoint)", imageName: data.value.imageNameDetail) { image in
                        pair.append(image)
                        self.tempImageData[data.key] = pair
                        innerGroup.leave()
                    }
                }
            } else {
                let imageHome = imageData[data.key]![0]
                let imageDetail = imageData[data.key]![1]
                if imageHome == nil && imageDetail == nil {
                    getImage("\(self.endPoint)", imageName: data.value.imageNameHome) { image in
                        pair.append(image)
                        getImage("\(self.endPoint)", imageName: data.value.imageNameDetail) { image in
                            pair.append(image)
                            self.tempImageData[data.key] = pair
                            innerGroup.leave()
                        }
                    }
                } else if imageHome == nil {
                    getImage("\(self.endPoint)", imageName: data.value.imageNameHome) { image in
                        pair.append(image)
                        pair.append(imageDetail)
                        self.tempImageData[data.key] = pair
                        innerGroup.leave()
                    }
                } else if imageDetail == nil {
                    getImage("\(self.endPoint)", imageName: data.value.imageNameDetail) { image in
                        pair.append(imageHome)
                        pair.append(image)
                    self.tempImageData[data.key] = pair
                    innerGroup.leave()
                    }
                } else {
                    pair.append(imageHome)
                    pair.append(imageDetail)
                    self.tempImageData[data.key] = pair
                    innerGroup.leave()
                }
            }
        }
        innerGroup.notify(queue: .main) {
            outerGroup.leave()
        }
    }
}


func loadEventData() -> [String: Event] {
    let filename = "eventData.json"
    let data: Data
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        print("Cound't find \(filename)")
        return [String: Event]()
    }
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        print("Couldn't load \(filename):\n\(error)")
        return [String: Event]()
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([String: Event].self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \([String: Event].self):\n\(error)")
        return [String: Event]()
    }
}

func loadOrganizerData() -> [String: Organizer] {
    let filename = "organizerData.json"
    let data: Data
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        print("Cound't find \(filename)")
        return [String: Organizer]()
    }
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        print("Couldn't load \(filename):\n\(error)")
        return [String: Organizer]()
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode([String: Organizer].self, from: data)
    } catch {
        print("Couldn't parse \(filename) as \([String: Event].self):\n\(error)")
        return [String: Organizer]()
    }
}

func loadImage(_ name: String) -> UIImage? {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentsDirectory.appendingPathComponent(name)
    guard let image = UIImage(contentsOfFile: fileURL.path)
        else {
            print("Couldn't parse \(name)")
            return nil
    }
    return image
}

enum SortBy: String, CaseIterable {
    case all = "All"
    case arts = "Arts"
    case careers = "Careers"
    case economics = "Economics"
    case history = "History"
    case mathematics = "Mathematics"
    case philosophy = "Philosophy"
    case politics = "Politics"
    case science = "Science"
    case sociology = "Sociology"
    case technology = "Technology"
}
