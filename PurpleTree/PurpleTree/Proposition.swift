//
//  Proposition.swift
//  Purpletree
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI
struct Proposition: View {
    @State var showingAlert = false
    @State var alertType = AlertType.asked
    @State var email: String = UserDefaults.standard.string(forKey: "DraftEmail") ?? UserDefaults.standard.string(forKey: "Email") ?? "" {
        didSet { UserDefaults.standard.set(email, forKey: "DraftEmail")
        }
    }
    @State var organizer: String = UserDefaults.standard.string(forKey: "DraftOrganizer") ?? "" {
        didSet { UserDefaults.standard.set(organizer, forKey: "DraftOrganizer")
        }
    }
    @State var description: String = UserDefaults.standard.string(forKey: "DraftDescription") ?? "" {
        didSet { UserDefaults.standard.set(organizer, forKey: "DraftDescription")
        }
    }
    
    enum AlertType {
       case empty, invalid, proposed, asked, failed
    }
    
    var addButton: some View {
        Button(action: {self.propose()}) {
            Image(systemName: "plus")
            .imageScale(.large)
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            .accessibility(label: Text("Add Event"))
        }
    }
    var askButton: some View {
        Button(action: {
            self.showingAlert.toggle()
            self.alertType = .asked
        }) {
            Image(systemName: "questionmark")
            .imageScale(.large)
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            .accessibility(label: Text("Ask"))
        }
    }

    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack{
                    List {
                        HStack{
                            Text("From")
                            .foregroundColor(.gray)
                            TextField("leaves@purpletree", text: self.$email)
                        }
                        HStack{
                            Text("By")
                            .foregroundColor(.gray)
                            TextField("club, group, dept", text: self.$organizer)
                        }
                        MultilineTextView(placeholderText: "one or two sentences that describe the event", text: self.$description)
                            .frame(height: proxy.size.height)
                    }
                    Spacer()
                }
                .alert(isPresented: self.$showingAlert) {
                    switch self.alertType {
                    case .asked:
                        return Alert(title: Text("Helper"), message: Text("You can create your own event on this page. After submitting the form, you will be contacted through email for details. Your event will be put out after its approval."), dismissButton: .default(Text("Got it")))
                    case .proposed:
                        return Alert(title: Text("Success"), message: Text("You have created a new event. We will get back to you shortly."), dismissButton: .default(Text("OK")))
                    case .failed:
                        return Alert(title: Text("Error"), message: Text("Cannot submit your form due to an internet problem. Try again later."), dismissButton: .default(Text("OK")))
                    case .empty:
                        return Alert(title: Text("Error"), message: Text("One or more places are empty."), dismissButton: .default(Text("OK")))
                    case .invalid:
                        return Alert(title: Text("Error"), message: Text("Please provide a valid email address for contact."), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationBarTitle(Text("New Event"))
                .navigationBarItems(trailing: HStack{
                    self.askButton
                    .padding(.trailing, 5)
                    self.addButton})
            }
        }
    }
    func clear() -> Void {
        email = ""
        organizer = ""
        description = ""
        UserDefaults.standard.removeObject(forKey: "DraftEmail")
    }
    func propose() -> Void {
        if email == "" || organizer == "" || description == "" {
            self.showingAlert = true
            self.alertType = .empty
            
        } else if !validateEmail(email) {
            self.showingAlert = true
            self.alertType = .invalid
            
        } else {
            post("\(UserData.shared.endPoint)propose/", dic: ["email": self.email, "organizer": self.organizer, "description": self.description]) { feedback in
                if feedback == "done" {
                    self.clear()
                    self.showingAlert = true
                    self.alertType = .proposed
                } else {
                    self.showingAlert = true
                    self.alertType = .failed
                }
            }
        }
    }
}

func validateEmail(_ email: String) -> Bool{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}


struct MultilineTextView: UIViewRepresentable {
    var placeholderText: String
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.textContainer.lineFragmentPadding = 0
        view.font = UIFont.systemFont(ofSize: 17)
        view.text = placeholderText
        view.textColor = .placeholderText
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.delegate = context.coordinator
        if text != "" || uiView.textColor == .label {
            uiView.text = text
            uiView.textColor = .label
        }
    }
    
    func frame(numLines: CGFloat) -> some View {
        let height = UIFont.systemFont(ofSize: 17).lineHeight * numLines
        return self.frame(height: height)
    }
     
    func makeCoordinator() -> MultilineTextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextView
        init(_ parent: MultilineTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = parent.placeholderText
                textView.textColor = .placeholderText
            }
        }
    }
}
