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
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    Profile(screenSize: proxy.size, image: self.event.image, observed: self.event.loader)
                    SpeakerDescription(event: self.event, interested: UserDefaults.standard.bool(forKey: self.event.id), observed: self.event.interest)
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

struct Profile: View {
    let screenSize: CGSize
    @State var image: UIImage
    @ObservedObject var observed: ImageLoader
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: screenSize.width, height: screenSize.height*5/8)
            .clipped()
            .onReceive(observed.didChange) {image in
                self.image = image
        }
    }
}

struct SpeakerDescription: View {
    var event: Event
    @State var interested: Bool
    @ObservedObject var observed: Interest
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.speaker)
                    .font(.title)
                Text(event.speakerTitle).italic()
                    .font(.subheadline)
                HStack(alignment: .top) {
                    Group {
                        Text(event.date!)
                        Text(event.time)
                    }
                    .font(.subheadline)
                }
                Text(event.location)
                .font(.subheadline)
            }
            Spacer()
            Button(action: {
                self.observed.yes.toggle()
            }) {
                VStack{
                    if self.interested {
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
                .onReceive(observed.didChange) { interested in self.interested = interested}
            }
        }
    }
}
