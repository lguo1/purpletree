//
//  EventList.swift
//  PurpleTree
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct EventList: View {
    var body: some View {
        NavigationView {
            List(eventData) { event in
                 EventRow(event: event)
            }
            .navigationBarTitle(Text("Purple Tree"))
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
    }
}
