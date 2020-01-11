//
//  Email.swift
//  Purpletree
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct Email: View {
    @State var alert = false
    @State var alertType = AlertType.empty
    @State var success = false
    @State var internetError = false
    @State var invalidEmail = false
    @State var emptyEmail = false
    @State var email: String = ""
    @EnvironmentObject var userData: UserData
    var organizer: Organizer
    enum AlertType {
        case subscribed, internetError, invalid, empty, unsubscribed
    }
    var submitButton: some View {
        Button(action: {
            self.submit()
        }) {
            Image(systemName: "checkmark")
            .imageScale(.large)
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
        }
    }
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if organizer.subscribed {
                    Text("To unsubscribe from \(organizer.id), please provide your subscribed email address.")
                    .font(.headline)
                    .padding()
                } else {
                    Text("To join the mailing list of \(organizer.id), please provide your email address below.")
                    .font(.headline)
                    .padding()
                }
                TextField("leaves@purpletree", text: self.$email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                    .padding(.trailing)
                Spacer()
            }
            .navigationBarTitle(Text("Email"))
            .navigationBarItems(trailing: submitButton)
        }
        .alert(isPresented: $alert) {
            switch alertType {
            case .subscribed:
                return Alert(title: Text("Subscribed"), message: Text("Thank your for joining the mailing list of \(organizer.id)."), dismissButton: .default(Text("OK")))
            case .unsubscribed:
                return Alert(title: Text("Unsubscribed"), message: Text("You have unsubscribed from \(organizer.id)."), dismissButton: .default(Text("OK")))
            case .internetError:
                return Alert(title: Text("Error"), message: Text("Cannot subcribe to the mailing list of \(organizer.id) due to an internet problem. Try again later."), dismissButton: .default(Text("OK")))
            case .invalid:
                return Alert(title: Text("Error"), message: Text("Please provide a valid email address."), dismissButton: .default(Text("OK")))
            case .empty:
                return Alert(title: Text("Error"), message: Text("Empty email address"), dismissButton: .default(Text("Close")))
            }
        }
    }
    func submit() {
        if email == "" {
            self.alert = true
            self.alertType = .empty
        } else if validateEmail(email) {
            UserDefaults.standard.set(email, forKey: "Email")
            post("\(UserData.shared.endPoint)subscribe/", dic: ["email": email, "organizer": organizer.id]) {feedback in
                if feedback != nil {
                   DispatchQueue.main.async { self.userData.organizerData[self.organizer.id]!.subscribed = !self.userData.organizerData[self.organizer.id]!.subscribed
                    }
                    self.alert = true
                    if self.organizer.subscribed {
                        self.alertType = .unsubscribed
                    } else {
                        self.alertType = .subscribed
                    }
                } else {
                    self.alert = true
                    self.alertType = .internetError
                }
            }
        } else {
            self.alert = true
            self.alertType = .invalid
        }
    }
}

