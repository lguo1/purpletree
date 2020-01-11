//
//  Feedback.swift
//  Purpletree
//
//  Created by apple on 2020/1/8.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI
struct Feedback: View {
    @State var showingAlert = false
    @State var alertType = AlertType.failed
    @State var email = UserDefaults.standard.string(forKey: "FeedbackEmail") ?? UserDefaults.standard.string(forKey: "Email") ?? "" {
        didSet {
            UserDefaults.standard.set(email, forKey: "FeedbackEmail")
        }
    }
    @State var content = UserDefaults.standard.string(forKey: "FeedbackContent") ?? "" { didSet {
        UserDefaults.standard.set(email, forKey: "FeedbackEmail")
        }
    }
    enum AlertType {
       case empty, invalid, submitted, failed
    }
    var submitButton: some View {
        Button(action: {self.submit()}) {
            Image(systemName: "checkmark")
            .imageScale(.large)
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            .accessibility(label: Text("Add Event"))
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    List {
                        HStack {
                            Text("From")
                            .foregroundColor(.gray)
                            TextField("leaves@purpletree", text: self.$email)
                        }
                        MultilineTextView(placeholderText: "a penny for your thoughts", text: self.$content)
                        .frame(height: proxy.size.height)
                    }
                    Spacer()
                }
                .alert(isPresented: self.$showingAlert) {
                    switch self.alertType {
                    case .empty:
                        return Alert(title: Text("Error"), message: Text("One or more places are empty."), dismissButton: .default(Text("OK")))
                    case .invalid:
                        return Alert(title: Text("Error"), message: Text("Please provide a valid email address."), dismissButton: .default(Text("OK")))
                    case .submitted:
                        return Alert(title: Text("Submitted"), message: Text("Thank you for your feedback"), dismissButton: .default(Text("OK")))
                    case .failed:
                        return Alert(title: Text("Failed"), message: Text("Cannot send the feedback because of internet. Try again later."), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationBarTitle(Text("Feedback"))
                .navigationBarItems(trailing: self.submitButton)
            }
        }
    }
    
    func clear() -> Void {
        content = ""
        UserDefaults.standard.removeObject(forKey: "FeedbackEmail")
    }
    
    func submit() -> Void {
        if email == "" {
            self.showingAlert = true
            self.alertType = .empty
        } else if validateEmail(email) {
            post("\(UserData.shared.endPoint)feedback/", dic: ["email": self.email, "content": self.content]) { feedback in
                if feedback == "done" {
                    self.clear()
                    self.showingAlert = true
                    self.alertType = .submitted
                } else {
                    self.showingAlert = true
                    self.alertType = .failed
                }
            }
        } else {
            self.showingAlert = true
            self.alertType = .invalid
        }
    }
}
