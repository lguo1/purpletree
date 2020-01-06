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
    @Binding var subscribed: Bool
    enum AlertType {
        case subscribed, internetError, invalid, empty, unsubscribed
    }
    var organizer: String
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
                Text("To subscribe to the mailing list of \(organizer), please provide your email address below.")
                    .font(.headline)
                    .padding()
                List {
                    TextField("leaves@purpletree", text: self.$email)
                        .padding(.leading)
                }
                Spacer()
            }
            .navigationBarTitle(Text("Email"))
            .navigationBarItems(trailing: submitButton)
        }
        .alert(isPresented: $alert) {
            switch alertType {
            case .subscribed:
            return Alert(title: Text("Subscribed"), message: Text("Thank your for joining the mailing list of \(organizer)."), dismissButton: .default(Text("OK")))
            case .unsubscribed:
            return Alert(title: Text("Unsubscribed"), message: Text("You have unsubscribed from the mailing list of \(organizer)."), dismissButton: .default(Text("Close")))
            case .internetError:
                return Alert(title: Text("Error"), message: Text("Cannot subcribe to the mailing list of \(organizer) due to an internet problem. Try again later."), dismissButton: .default(Text("OK")))
            case .invalid:
                return Alert(title: Text("Error"), message: Text("Please provide a valid email address for contact."), dismissButton: .default(Text("OK")))
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
            post("\(UserData.shared.baseUrlString)subscribe/", dic: ["email": email, "organizer": organizer]) {feedback in
                if feedback != nil {
                    if self.subscribed {
                        self.subscribed = false
                        self.alert = true
                        self.alertType = .unsubscribed
                    } else {
                        self.subscribed = true
                        self.alert = true
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

func validateEmail(_ email: String) -> Bool{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
