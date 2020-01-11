//
//  Event.swift
//  Purple Tree
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct Event: Hashable, Codable, Identifiable {
    var id: String
    var interest: Bool
    var speaker: String
    var speakerHome: String
    var speakerTitle: String
    var time: String
    var weekday: String
    var date: String
    var season: String
    var year: String
    var start: String
    var end: String
    var imageNameHome: String
    var imageNameDetail: String
    var category: Category
    var location: String
    var description: String
    var decided: Bool
    var red : Double
    var green : Double
    var blue : Double
    var organizer: String
    var funding: Bool
    var bundle: String?
    var background: String?
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
        case careers = "Careers"
    }
}
