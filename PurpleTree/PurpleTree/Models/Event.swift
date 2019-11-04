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
    var id: Int
    var speaker: String
    var speakerTitle: String
    var time: String
    var weekday: String
    var monthday: String
    var month: String
    var date: String
    var season: String
    var year: String
    fileprivate var imageName: String
    var category: Category
    var location: String
    var description: String
    var interested: Bool
    var isDetermined: Bool
    
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
