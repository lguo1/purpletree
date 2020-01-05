//
//  Email.swift
//  Purpletree
//
//  Created by apple on 2020/1/5.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct Email: View {
    @State var email: String = ""
    @State var success = false
    @State var internetError = false
    @State var invalidEmail = false
    @Binding var subscribed: Bool
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
            VStack{
                Text("Please provide your email for subscription.")
                .font(.headline)
                .padding(.bottom, 30)
                TextField("leaves@purpletree", text: self.$email)
            }
            .navigationBarTitle(Text("Email"))
            .navigationBarItems(trailing: submitButton)
        }
        .alert(isPresented: $success) {
            Alert(title: Text("Subscribed"), message: Text("You have joined the mailing list of \(organizer)."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $internetError) {
        Alert(title: Text("Error"), message: Text("Internet problem. Try again later."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $invalidEmail) {
        Alert(title: Text("Error"), message: Text("Your email address is invalid."), dismissButton: .default(Text("OK")))
        }
    }
    func submit() {
        if validateEmail(email) {
            propose("\(UserData.shared.baseUrlString)subscribe/", proposal: ["email": email, "organizer": organizer]) {feedback in
                if feedback != nil {
                    self.subscribed = true
                    self.success = true
                } else {
                    self.internetError = true
                }
            }
        } else {
            self.invalidEmail = true
        }
    }
}

func validateEmail(_ email: String) -> Bool{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
