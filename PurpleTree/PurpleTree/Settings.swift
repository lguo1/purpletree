//
//  ProfileHost.swift
//  Purpletree
//
//  Created by apple on 2020/1/1.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var userData: UserData
    @Binding var sheetType: SheetType
    var name: String {
        if UserData.shared.name == ""{
            return "Your Name"
        } else {
            return UserData.shared.name
        }
    }
    var email: String {
        if UserData.shared.email == ""{
            return "leaves@purpletree"
        } else {
            return UserData.shared.email
        }
    }
    var body: some View {
        NavigationView {
            Form{
                Section{
                    NavigationLink(destination: Login(name: $userData.name, email: $userData.email)) {
                        HStack{
                            Image(systemName: "person.crop.circle")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height:60)
                            .padding(.trailing, 8)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            VStack(alignment: .leading){
                                Text(name)
                                    .font(.system(size:21))
                                Text(email)
                            }
                            Spacer()
                        }
                    }
                }
                Section{
                    Toggle(isOn: $userData.prefersCalendar) {
                        Text("Enable Calendar Scheduling")
                    }
                    Picker("Sort by", selection: $userData.sortBy) {
                        ForEach(SortBy.allCases, id: \.self) { category in
                            Text(category.rawValue)
                        }
                    }
                    Button(action: {
                        self.userData.getData()
                    }) {
                        Text("Refresh")
                        .foregroundColor(Color.black)
                    }
                    Button(action: {
                        requestNotification()
                    }) {
                        Text("Allow Notifications")
                        .foregroundColor(Color.black)
                    }
                }
                Section {
                    Button(action: {
                        self.sheetType = .feedback
                    }) {
                        Text("Feedback")
                        .foregroundColor(Color.black)
                    }
                    Button(action: {
                        if let url = URL(string: "\(UserData.shared.endPoint)help/") {
                            UIApplication.shared.open(url)
                        }}) {
                        Text("Help")
                        .foregroundColor(Color.black)
                    }
                }
            }.navigationBarTitle(Text("Settings"))
        }
    }
}
