//
//  Notification.swift
//  PurpleTree
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct Notification: View {
    @EnvironmentObject private var userData: UserData
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Button(action: {
                    self.userData.get("https://ppe.sccs.swarthmore.edu/")
                }) {
                    Text("No Event")
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                    .font(.title)
                    .padding(.bottom, 10)
                }
                Text("You received no event because of either of the two things:")
                    .font(.headline)
                    .padding(.bottom, 30)
                HStack {
                    Text("1")
                        .font(.title)
                        .padding(.trailing, 10)
                    Text("You don't have internet connection. Check your connection and refresh by clicking the 'No Event' title.")
                }
                .padding(.bottom, 30)
                HStack {
                    Text("2")
                        .font(.title)
                        .padding(.trailing, 10)
                    Text("We haven't put out events yet. Stay tuned.")
                }
                Spacer()
            }.padding()
        }
    }
}
