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
    var imageHome: UIImage {
        ImageStore.shared.image(name: self.imageHomeName)
        return UIImage()
    }
    var imageDetail: UIImage {
        ImageStore.shared.image(name: self.imageDetailName)
        return UIImage()
    }
    var interest: Interest {
        Interest(id: self.id)
    }
    var homeLoader: ImageLoader {
        ImageLoader()
    }
    var detailLoader: ImageLoader {
        ImageLoader()
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
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
}
