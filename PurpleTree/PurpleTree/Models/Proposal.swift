//
//  Proposal.swift
//  Purpletree
//
//  Created by apple on 2020/1/3.
//  Copyright © 2020 purpletree. All rights reserved.
//

import Foundation

struct Proposal: Codable {
    var email: String
    var organizer: String
    var description: String
    static let `default` = Self(email: "Club, Group, Dept, etc", organizer: "", description: "")
    init(email: String, organizer: String, description: String) {
        self.email = email
        self.organizer = organizer
        self.description = description
    }
}
