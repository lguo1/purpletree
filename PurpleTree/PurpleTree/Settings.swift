//
//  ProfileHost.swift
//  Purpletree
//
//  Created by apple on 2020/1/1.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI
import UserNotifications

struct Settings: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        NavigationView {
            Form{
                Section{
                    Toggle(isOn: $userData.prefersCalendar) {
                        Text("Enable Calendar Scheduling")
                    }
                    Picker("Sort by", selection: $userData.sortBy) {
                        ForEach(UserData.SortBy.allCases, id: \.self) {
                            category in
                            Text(category.rawValue)
                        }
                    }
                    Button(action: {
                        self.userData.get("https://ppe.sccs.swarthmore.edu/")
                    }) {
                        Text("Refresh Home Page")
                        .foregroundColor(Color.black)
                    }
                }
            }.navigationBarTitle(Text("Settings"))
        }
    }
}
