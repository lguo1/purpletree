//
//  OrganizerDetail.swift
//  Purpletree
//
//  Created by apple on 2020/1/7.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct OrganizerDetail: View {
    let organizer: Organizer
    var body: some View {
        NavigationView {
            VStack{
                Text(organizer.overview)
                .font(.headline)
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text(organizer.id))
        }
    }
}
