//
//  Event.swift
//  Purple Tree
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

struct Event: Hashable, Codable, Identifiable, Equatable {
    var id: String
    var speaker: String
    var speakerHome: String
    var speakerTitle: String
    var time: String
    var weekday: String
    var date: String
    var season: String
    var year: String
    var start: String?
    var end: String?
    var homeImageName: String
    var detailImageName: String
    var category: Category
    var location: String
    var description: String
    var current: Bool
    var red : Double
    var green : Double
    var blue : Double
    var organizer: String
    enum Category: String, CaseIterable, Codable, Hashable {
        case arts = "Arts"
        case economics = "Economics"
        case history = "History"
        case mathematics = "Mathematics"
        case philosophy = "Philosophy"
        case politics = "Politics"
        case science = "Science"
        case sociology = "Sociology"
        case technology = "Technology"
    }
    static func == (lhs: Event, rhs: Event) -> Bool {
        return
            lhs.speaker == rhs.speaker &&
            lhs.start == rhs.start &&
            lhs.end == rhs.end &&
            lhs.description == rhs.description
    }
}

extension Event {
    var loader: Loader {
        Loader(id: self.id, speaker: self.speaker, start: self.start, end: self.end, description: self.description, homeImageName: self.homeImageName, detailImageName: self.detailImageName)
    }
}

final class Loader: ObservableObject {
    var interest = false
    var showingAlert = false
    var id: String
    var speaker: String
    var start: String?
    var end: String?
    var description: String
    @Published var homeImage = UIImage()
    @Published var detailImage = UIImage()
    @Published var changeInterest = Bool() {
        didSet {
            UserDefaults.standard.set(changeInterest, forKey: id)
            interest = changeInterest
            if start != nil && UserData.shared.prefersCalendar {
                if changeInterest {
                    addToCalendar(id: id, speaker: speaker, start: start!, end: end!, description: description)
                    showingAlert = true
                } else {
                    removeFromCalendar(id: id)
                    showingAlert = false
                }
            }
        }
    }
    init(id: String, speaker: String, start: String?, end: String?, description: String, homeImageName: String, detailImageName: String) {
        self.id = id
        self.speaker = speaker
        self.start = start
        self.end = end
        self.description = description
        if let image = loadImage(name: homeImageName) {
            self.homeImage = image
            print("find local \(homeImageName)")
        } else {
            guard let homeUrl = URL(string:"\(UserData.shared.endPoint)img/\(homeImageName)/") else { return }
            let homeTask = URLSession.shared.dataTask(with: homeUrl) { data, response, error in
                guard let data = data else { return }
                self.saveImageData(imageName: homeImageName, data: data)
                DispatchQueue.main.async {
                    self.homeImage = UIImage(data: data)!
                }
            }
            homeTask.resume()
        }
        if let image = loadImage(name: detailImageName) {
            self.detailImage = image
            print("find local \(detailImageName)")
        } else {
            guard let detailUrl = URL(string: "\(UserData.shared.endPoint)img/\(detailImageName)/") else { return }
            let detailTask = URLSession.shared.dataTask(with: detailUrl) { data, response, error in
                guard let data = data else { return }
                self.saveImageData(imageName: homeImageName, data: data)
                DispatchQueue.main.async {
                    self.detailImage = UIImage(data: data)!
                }
            }
            detailTask.resume()
        }
    }
    func saveImageData(imageName: String, data: Data) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving \(imageName)", error)
            }
        }
    }
    func loadImage(name: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        guard let image = UIImage(contentsOfFile: fileURL.path)
            else {
                return nil
        }
        return image
    }
}
