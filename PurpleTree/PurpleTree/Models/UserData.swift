//
//  UserData.swift
//  PurpleTree
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 purpletree. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var events = eventData
}
