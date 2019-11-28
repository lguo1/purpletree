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
    var speakerTitle: String
    var time: String
    var weekday: String?
    var monthday: String?
    var month: String?
    var date: String?
    var season: String
    var year: String
    var imageName: String
    var category: Category?
    var location: String
    var description: String
    var current: Bool
    enum Category: String, CaseIterable, Codable, Hashable {
        case politics = "Politics"
        case economics = "Economics"
        case philosophy = "Philosophy"
    }
}

extension Event {
    var image: UIImage {
        ImageStore.shared.image(name: self.imageName)
    }
    var interest: Interest {
        Interest(id: self.id)
    }
    var loader: ImageLoader {
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
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }
}
