//
//  SpeakerList.swift
//  Purple Tree
//
//  Created by apple on 2019/10/4.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct SpeakerList: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
            Toggle(isOn: $userData.showFavoritesOnly) {
                Text("Show Favorites Only")
                }
            }
        }
    }
}

struct SpeakerList_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerList()
    }
}
