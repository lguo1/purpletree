//
//  Proposition.swift
//  Purpletree
//
//  Created by apple on 2020/1/4.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

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


struct Proposition: View {
    @State var created = false
    @State var email: String = ""
    @State var organizer: String = ""
    @State var description: String = ""
    var createButton: some View {
        Button(action: {self.create()}) {
            Text("Create")
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
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
                .navigationBarTitle(Text("New Event"))
                .navigationBarItems(trailing: self.createButton)
            }
        }
    }
    func create() -> Void {
        let proposal = ["email": self.email, "organizer": self.organizer, "description": self.description]
        propose("localhost:5050/add/", proposal: proposal) { feedback in
            if feedback == "done" {
                DispatchQueue.main.async{
                    self.created = true
                }
            }
        }
    }
}

struct Proposition_Previews: PreviewProvider {
    static var previews: some View {
        Proposition()
    }
}
