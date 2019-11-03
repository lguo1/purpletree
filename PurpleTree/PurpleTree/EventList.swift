//
//  EventList.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct EventList: View {
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack {
                    TopLogo(screenSize: proxy.size)
                    List(EventData) { event in
                        NavigationLink(destination: EventDetail(event: event)) {
                            EventRow(screenSize: proxy.size, speaker: event.speaker)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        EventList()
    }
}

struct EventRow: View {
    let screenSize: CGSize
    var speaker: String
    var body: some View {
        HStack {
            Text(speaker)
                .padding(.leading, screenSize.width/6)
                .font(.title)
                .frame(height: screenSize.width/6)
        }
    }
}

struct TopLogo: View {
    let screenSize: CGSize
    var body: some View {
        HStack {
            Image("top_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: screenSize.width/8)
                .padding(.leading)
                .padding(.top)
            Spacer()
        }
    }
}
