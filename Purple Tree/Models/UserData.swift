//
//  UserData.swift
//  Purple Tree
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019 purpletree. All rights reserved.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var event = EventData  
}
