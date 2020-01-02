//
//  Profile.swift
//  Purpletree
//
//  Created by apple on 2020/1/1.
//  Copyright © 2020 purpletree. All rights reserved.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotification: Bool
    var category: Category
    static let `default` = Self(username: "Your Name", prefersNotification: true, category: .all)
    init(username: String, prefersNotification: Bool, category: Category) {
        self.username = username
        self.prefersNotification = prefersNotification
        self.category = category
    }
    enum Category: String, CaseIterable {
        case all = "All"
        case politics = "Politics"
        case economics = "Economics"
        case philosophy = "Philosophy"
        case other = "Other"
    }
}
