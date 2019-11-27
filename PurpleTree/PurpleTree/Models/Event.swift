//
//  Event.swift
//  Purple Tree
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI
import CoreLocation

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
    var image: Image {
        ImageStore.shared.image(name: self.imageName)
    }
    var interest: Interest {
        Interest(id: self.id)
    }
    var observer: ImageObserver{
        ImageObserver(subject: UserData.shared, id: self.id)
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
