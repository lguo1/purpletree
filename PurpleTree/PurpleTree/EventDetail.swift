//
//  EventDetail.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct EventDetail: View {
    @EnvironmentObject private var loader: Loader
    var event: Event
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Profile(event: self.event, screenSize: proxy.size)
                Spacer()
                }
            .overlay(ScrollView(.vertical, showsIndicators: false) {
                Description(event:self.event, screenSize: proxy.size)
            })
            }
        .edgesIgnoringSafeArea(.top)
    }
}

struct Profile: View {
    @EnvironmentObject private var loader: Loader
    var event: Event
    let screenSize: CGSize
    var body: some View {
        Color(red: event.red, green: event.green, blue: event.blue)
            .frame(height: screenSize.height*5/8)
        .overlay(
            VStack {
                Spacer()
                Image(uiImage: loader.detailImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width)
            })
    }
}

struct Description: View {
    var event: Event
    let screenSize: CGSize
    var body: some View {
        VStack {
            Spacer()
                .frame(height: screenSize.height/2)
            VStack(alignment: .leading){
                SpeakerDescription(event: self.event, interested: UserDefaults.standard.bool(forKey: self.event.id), observed: self.event.interest)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                Text(self.event.description)
                    .padding(.leading)
                    .padding(.trailing)
                Spacer()
            }
            .background(
                Color(.white)
                .frame(height: screenSize.height*2)
                .cornerRadius(10)
                .shadow(radius: 5)
                , alignment: .top
            )
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
                Group {
                Text(event.speaker)
                    .font(.title)
                    .padding(.bottom, 10)
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
                .padding(.trailing)
                .padding(.leading)
                
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
                                .frame(height: 30)
                                .padding()
                    } else {
                        Text("Like")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                        .padding()
                    }
                }
                .onReceive(observed.didChange){
                    interested in self.interested = interested}
            }
        }
    }
}
