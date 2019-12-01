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
    var loader: Loader {
        Loader(homeImageName: self.imageHomeName, detailImageName: self.imageDetailName)
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

final class Loader: ObservableObject {
    @Published var homeImage = UIImage()
    @Published var detailImage = UIImage()
    init(homeImageName: String, detailImageName: String) {
        guard let homeUrl = URL(string: "http://localhost:5050/img/\(homeImageName)/") else { return }
        let homeTask = URLSession.shared.dataTask(with: homeUrl) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.homeImage = UIImage(data: data)!
            }
        }
        homeTask.resume()
        guard let detailUrl = URL(string: "http://localhost:5050/img/\(detailImageName)/") else { return }
        let detailTask = URLSession.shared.dataTask(with: detailUrl) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.detailImage = UIImage(data: data)!
            }
        }
        detailTask.resume()
    }
}
