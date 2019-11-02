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
    var logo: Image
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Profile(screenSize: proxy.size, event: self.event)
                SpeakerDescription(screenSize: proxy.size, event: self.event, logo: self.logo)
                    .padding(.bottom, proxy.size.height/24)
                Text(self.event.description).italic()
                Spacer()
                }
            }
        .edgesIgnoringSafeArea(.top)
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: EventData[0], logo: Image("logo"))
    }
}

struct Profile: View {
    let screenSize: CGSize
    var event: Event
    var body: some View {
        event.image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: screenSize.width, height: screenSize.height*5.5/8)
            .clipped()
    }
}

struct SpeakerDescription: View {
    let screenSize: CGSize
    var event: Event
    var logo: Image
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.speaker)
                    .font(.title)
                    .fontWeight(.heavy)
                Text(event.speakerTitle)
                    .font(.subheadline)
                HStack(alignment: .top) {
                    Group {
                        Text(event.day)
                        Text(event.date)
                        Text(event.time)
                    }
                    .font(.subheadline)
                }
            }
            Spacer()
            logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: screenSize.height/16
            )
        }
        //.background(Rectangle().fill(Color.white).frame(height: screenSize.height*9/64))
        
    }
}
