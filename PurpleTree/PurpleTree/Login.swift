//
//  Login.swift
//  Purpletree
//
//  Created by apple on 2020/1/10.
//  Copyright © 2020 purpletree. All rights reserved.
//

import SwiftUI

struct Login: View {
    @Binding var name: String
    @Binding var email: String
    var body: some View {
        Form {
            Section(header: Text("NAME")) {
                TextField("Purple Leaves", text: self.$name)
            }
            Section(header: Text("REACHABLE AT"), footer: Text("This email address will be used to subscribe you to student clubs, contact you after you submit an event proposal. ")) {
                TextField("leaves@purpletree.com", text: self.$email)
            }
        }
    }
}
