//
//  Event.swift
//  PurpleTree
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Event: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var speaker: String
    fileprivate var imageName: String
    var category: Category
    var isFavorite: Bool
    var location: String
    var speakerTitle: String
    var day: String
    var date: String
    var time: String
    enum Category: String, CaseIterable, Codable, Hashable {
        case politics = "Politics"
        case economics = "Economics"
        case philosophy = "Philosophy"
    }
}

extension Event {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
