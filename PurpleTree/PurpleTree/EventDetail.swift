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
                    .environmentObject(self.loader)
                Spacer()
                }
            .overlay(ScrollView(.vertical, showsIndicators: false) {
                Description(event:self.event, screenSize: proxy.size)
                    .environmentObject(self.loader)
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
    @EnvironmentObject private var loader: Loader
    var event: Event
    let screenSize: CGSize
    var body: some View {
        VStack {
            Spacer()
                .frame(height: screenSize.height/2)
            VStack(alignment: .leading){
                SpeakerDescription(event: event)
                    .environmentObject(loader)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                Text(event.description)
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
    @EnvironmentObject private var loader: Loader
    var event: Event
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
                self.loader.interest.toggle()
            }) {
                VStack{
                    if loader.interest {
                            Image("logo")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .padding()
                    } else {
                        Text("Like")
                        .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                        .padding()
                    }
                }
            }
        }
    }
}
