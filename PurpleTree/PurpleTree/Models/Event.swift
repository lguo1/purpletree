//
//  Event.swift
//  Purple Tree
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI
import CoreLocation
import Combine

struct Event: Hashable, Codable, Identifiable {
    var id: String
    var speaker: String
    var speakerHome: String
    var speakerTitle: String
    var time: String
    var weekday: String
    var date: String
    var season: String
    var year: String
    var imageHomeName: String
    var imageDetailName: String
    var category: Category?
    var location: String
    var description: String
    var current: Bool
    var red : Double
    var green : Double
    var blue : Double
    enum Category: String, CaseIterable, Codable, Hashable {
        case politics = "Politics"
        case economics = "Economics"
        case philosophy = "Philosophy"
        case other = "Other"
    }
}

extension Event {
    var loader: Loader {
        Loader(id: self.id, homeImageName: self.imageHomeName, detailImageName: self.imageDetailName)
    }
}

final class Loader: ObservableObject {
    private var id: String
    @Published var yes = Bool() {
        didSet {
            UserDefaults.standard.set(yes, forKey: self.id)
        }
    }
    init(id: String) {
        self.id = id
    }
    @Published var homeImage = UIImage()
    @Published var detailImage = UIImage()
    init(id: String, homeImageName: String, detailImageName: String) {
        self.id = id
        if let image = ImageStore.shared.image(name: homeImageName) {
            self.homeImage = image
            print("find local \(homeImageName)")
        } else {
            guard let homeUrl = URL(string: "https://ppe.sccs.swarthmore.edu/img/\(homeImageName)/") else { return }
            let homeTask = URLSession.shared.dataTask(with: homeUrl) { data, response, error in
                guard let data = data else { return }
                self.saveImageData(imageName: homeImageName, data: data)
                DispatchQueue.main.async {
                    self.homeImage = UIImage(data: data)!
                }
            }
            homeTask.resume()
        }
        if let image = ImageStore.shared.image(name: detailImageName) {
            self.detailImage = image
            print("find local \(detailImageName)")
        } else {
            guard let detailUrl = URL(string: "https://ppe.sccs.swarthmore.edu/img/\(detailImageName)/") else { return }
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
}
