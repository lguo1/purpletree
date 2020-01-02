//
//  ProfileHost.swift
//  Purpletree
//
//  Created by apple on 2020/1/1.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct ProfileHost: View {
    @EnvironmentObject var userData: UserData
    @State var draftProfile = Profile.default
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                TextField("Your Name", text: $draftProfile.username)
                .font(.title)
                .padding(.top, 30)
                .padding(.bottom, 30)
                Toggle(isOn: $draftProfile.prefersNotification) {
                    Text("Enable Notifications")
                }
                .padding(.bottom, 5)
                Text("Sort By")
                Picker("Sort By", selection: $draftProfile.category) {
                    ForEach(Profile.Category.allCases, id: \.self) {
                        category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 5)
                Button(action: {
                    self.userData.get("https://ppe.sccs.swarthmore.edu/")
                }) {
                    Text("Refresh Home Page")
                    .foregroundColor(Color.black)
                }
                .padding(.bottom, 5)
                Spacer()
            }
            .padding()
        }
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
    }
}
