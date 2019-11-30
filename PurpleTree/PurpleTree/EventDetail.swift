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
                    Profile(event: self.event, screenSize: proxy.size)
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
    var event: Event
    let screenSize: CGSize
    var body: some View {
        Color(red: event.red, green: event.green, blue: event.blue)
            .frame(height: screenSize.height*5/8)
        .overlay(
            VStack {
                Spacer()
                Image(uiImage: event.homeLoader.data != nil ? UIImage(data: event.homeLoader.data!)! : UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width)
            })
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
                Text(event.speakerTitle)
                    .font(.subheadline)
                HStack(alignment: .top) {
                    Group {
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
                        Text("Like")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                    }
                }
                .onReceive(observed.didChange){
                    interested in self.interested = interested}
            }
        }
    }
}
