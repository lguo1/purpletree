//
//  EventRow.swift
//  PurpleTree
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    var body: some View {
        HStack {
            Text(event.speaker)
            .font(.system(size: 30))
        }
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: eventData[1])
    }
}
