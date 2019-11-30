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
    var interest: Interest {
        Interest(id: self.id)
    }
    var homeLoader: ImageLoader {
        ImageLoader(urlString: "http://localhost:5050/img/\(self.imageHomeName)/")
    }
    var detailLoader: ImageLoader {
        ImageLoader(urlString: "http://localhost:5050/img/\(self.imageHomeName)/")
    }
}

class Interest: ObservableObject {
    var id: String
    var didChange = PassthroughSubject<Bool, Never>()
    var yes = Bool() {
        didSet {
            UserDefaults.standard.set(yes, forKey: self.id)
            didChange.send(yes)
        }
    }
    init(id: String) {
        self.id = id
    }
}

final class ImageLoader: ObservableObject {
    @Published var image = UIImage()
    init(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)!
            }
        }
        task.resume()
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
