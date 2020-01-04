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
        view.textContainerInset = .zero
        //view.isScrollEnabled = true
        //view.isEditable = true
        //view.isUserInteractionEnabled = true
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
    @State private var email: String = ""
    @State private var organizer: String = ""
    @State private var description: String = ""

    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                Form {
                    Section {
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
                        VStack(alignment: .leading){
                            MultilineTextView(placeholderText: "one or two sentences that describe the event", text: self.$description)
                                .frame(height: proxy.size.height/2)
                            
                        }
                    }
                }
                .navigationBarTitle(Text("New Event"))
            }
        }
    }
}

struct Proposition_Previews: PreviewProvider {
    static var previews: some View {
        Proposition()
    }
}
