//
//  Organizer.swift
//  Purpletree
//
//  Created by apple on 2020/1/6.
//  Copyright © 2020 purpletree. All rights reserved.
//

import Foundation

struct Organizer: Hashable, Codable, Identifiable {
    var id: String
    var subscribed: Bool
    var overview: String
}
