//
//  OrganizerDetail.swift
//  Purpletree
//
//  Created by apple on 2020/1/7.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct OrganizerDetail: View {
    @EnvironmentObject var userData: UserData
    @State var alert = false
    @State var alertType = AlertType.subscribed
    @Binding var showingSheet: Bool
    @Binding var sheetType: SheetType
    let organizer: Organizer
    enum AlertType {
        case subscribed, unsubscribed, subscriptionError
    }
    var subscribeButton: some View {
        Button(action: {
            self.subscribe()
        }) {
            if userData.organizerData[organizer.id]!.subscribed {
                Image(systemName: "person.2.fill")
                .imageScale(.large)
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            } else {
                Image(systemName: "person.2")
                .imageScale(.large)
                .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack{
                Text(organizer.overview)
                .font(.headline)
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text(organizer.id))
            .navigationBarItems(trailing: subscribeButton)
        }
        .alert(isPresented: $alert) {
            switch alertType {
            case .subscribed:
                return Alert(title: Text("Subscribed"), message: Text("Thank you for joining the mailing list of \(organizer.id)."), dismissButton: .default(Text("Welcome")))
            case .unsubscribed:
                return Alert(title: Text("Unsubscribed"), message: Text("You have unsubscribed from \(organizer.id)."), dismissButton: .default(Text("OK")))
            case .subscriptionError:
                return Alert(title: Text("Failed"), message: Text("Cannot join the mailing list of \(organizer.id) due to an internet problem. Try again later."), dismissButton: .default(Text("OK")))
            }
        }
    }
    func subscribe() {
        if let email = UserDefaults.standard.string(forKey: "Email") {
            post("\(UserData.shared.endPoint)subscribe/", dic: ["email": email, "organizer": self.organizer.id]) {feedback in
                if feedback == "done" {
                    let old = self.userData.organizerData[self.organizer.id]!.subscribed
                   DispatchQueue.main.async {
                    self.userData.organizerData[self.organizer.id]!.subscribed = !old
                    }
                    if old {
                        self.alertType = .unsubscribed
                    } else {
                        self.alertType = .subscribed
                    }
                    self.alert = true
                } else {
                    self.alertType = .subscriptionError
                    self.alert = true
                }
            }
        } else {
            self.sheetType = .email
            self.showingSheet = true
        }
    }
}
