//
//  Home.swift
//  PurpleTree
//
//  Created by apple on 2019/11/3.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI
import Combine

struct Home: View{
    @EnvironmentObject private var userData: UserData
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    if userData.events.count == 0 {
                        NoEvent()
                            .environmentObject(userData)
                            .padding(.leading)
                            .padding(.bottom, 20)
                            .padding(.trailing)
                    } else {
                        ForEach(self.userData.events) {event in
                            HomeRow(event: event)
                                .environmentObject(event.loader)
                                .padding(.leading)
                                .padding(.bottom, 20)
                                .padding(.trailing)
                        }
                    }
                }
            }
            .navigationBarTitle(
            Text("PURPLETREE")
                .font(.title)
                .fontWeight(.heavy))
        }
    }
}

struct NoEvent: View {
    @EnvironmentObject private var userData: UserData
    var body: some View {
        HStack {
            NavigationLink(
            destination: Notification().environmentObject(userData)){
                VStack {
                    Color(red: 0.6, green: 0.4, blue: 0.6)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .overlay(
                        HStack {
                        Spacer()
                        VStack {
                            Text("No\nEvent")
                                .multilineTextAlignment(.trailing)
                                .font(.title)
                                .foregroundColor(Color.white)
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                            Spacer()
                        }
                    })
                }
            }
        }
    }
}
struct HomeRow: View {
    @EnvironmentObject private var loader: Loader
    var event: Event
    var body: some View {
        HStack {
            NavigationLink(
            destination: EventDetail(event: event).environmentObject(loader)){
                HomeItem(event: event).environmentObject(loader)
            }
        }
    }
}

struct HomeItem: View{
    @EnvironmentObject private var loader: Loader
    var event: Event
    var body: some View {
        VStack{
            Color(red: event.red, green: event.green, blue: event.blue)
                .frame(height: 200)
                .cornerRadius(10)
                .shadow(radius: 5)
            .overlay(
                HStack {
                    VStack {
                        Spacer()
                        Image(uiImage: loader.homeImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 180)
                            .padding(.leading, 10)
                    }
                    Spacer()
                })
            .overlay(
            HStack {
                Spacer()
                VStack {
                    Text(event.speakerHome)
                        .multilineTextAlignment(.trailing)
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                    Spacer()
                }
            })
        }
    }
}
