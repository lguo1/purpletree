//
//  Organizer.swift
//  Purpletree
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct Organizer: View {
    let organizer: String
    let overview: String
    var body: some View {
        NavigationView {
            VStack{
                Text(overview)
                .font(.headline)
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text(organizer))
        }
    }
}

