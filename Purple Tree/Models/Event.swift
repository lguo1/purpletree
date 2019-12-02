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
    var title: String
    fileprivate var imageName: String
    var category: Category
    var isFavorite: Bool
    var location: String
    
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
