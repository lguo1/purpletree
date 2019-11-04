//
//  EventDetail.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct EventDetail: View {
    var event: Event
    var logo: Image = Image("logo")
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Profile(screenSize: proxy.size, event: self.event)
                    SpeakerDescription(event: self.event, logo: self.logo).environmentObject(UserData())
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.bottom, proxy.size.height/24)
                    Text(self.event.description)
                        .padding(.leading)
                        .padding(.trailing)
                    Spacer()
                    }
                }
            }
        .edgesIgnoringSafeArea(.top)
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: EventData[0])
    }
}

struct Profile: View {
    let screenSize: CGSize
    var event: Event
    var body: some View {
        event.image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: screenSize.width, height: screenSize.height*5/8)
            .clipped()
    }
}

struct SpeakerDescription: View {
    var event: Event
    var logo: Image
    @EnvironmentObject var userData: UserData
    var eventIndex: Int {
        userData.events.firstIndex(where: { $0.id == event.id })!
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.speaker)
                    .font(.title)
                Text(event.speakerTitle).italic()
                    .font(.subheadline)
                HStack(alignment: .top) {
                    Group {
                        Text(event.weekday)
                        Text(event.date)
                        Text(event.time)
                    }
                    .font(.subheadline)
                }
                Text(event.location)
                .font(.subheadline)
            }
            Spacer()
            Button(action: {
                self.userData.events[self.eventIndex].interested.toggle()
            }) {
                if self.userData.events[self.eventIndex].interested {
                    Image("logo")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                } else {
                    Text("register")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                        .frame(height: 50)
                }
            }
        }
    }
}
