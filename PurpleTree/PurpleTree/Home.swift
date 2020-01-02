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
    @State var showingProfile = false
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle() }) {
            Image(systemName: "person.crop.circle")
                .foregroundColor(Color.black)
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
        }
    }
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        if self.userData.events.count == 0 {
                            NoEvent(screenSize: proxy.size)
                                .environmentObject(self.userData)
                                .padding(.leading)
                                .padding(.bottom, 20)
                                .padding(.trailing)
                        } else {
                            ForEach(self.userData.events) {event in
                                HomeRow(event: event, screenSize: proxy.size)
                                    .environmentObject(self.userData)
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
                .navigationBarItems(trailing: self.profileButton)
                    .sheet(isPresented: self.$showingProfile) {
                    ProfileHost()
                        .environmentObject(self.userData)
                }
            }
        }
    }
}

struct NoEvent: View {
    @EnvironmentObject private var userData: UserData
    let screenSize: CGSize
    var body: some View {
        HStack {
            NavigationLink(
            destination: Notification().environmentObject(userData)){
                VStack {
                    Color(red: 0.6, green: 0.4, blue: 0.6)
                    .frame(height: screenSize.height/2)
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
                    .overlay(
                        HStack{
                            VStack{
                                Spacer()
                                Image("tree")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: screenSize.width-30)
                            }
                            Spacer()
                        })
                }
            }
        }
    }
}
struct HomeRow: View {
    @EnvironmentObject private var userData: UserData
    var eventIndex: Int {
        userData.events.firstIndex(where: { $0.id == event.id })!
    }
    var event: Event
    let screenSize: CGSize
    var body: some View {
        HStack {
            NavigationLink(
            destination: EventDetail(event: event).environmentObject(userData.events[eventIndex].loader)){
                HomeItem(event: event, screenSize: screenSize).environmentObject(userData.events[eventIndex].loader)
            }
        }
    }
}

struct HomeItem: View{
    @EnvironmentObject private var loader: Loader
    var event: Event
    let screenSize: CGSize
    var body: some View {
        VStack{
            Color(red: event.red, green: event.green, blue: event.blue)
                .frame(height: screenSize.height/4)
                .cornerRadius(10)
                .shadow(radius: 5)
            .overlay(
                HStack {
                    VStack {
                        Spacer()
                        Image(uiImage: self.loader.homeImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: screenSize.height/4 - 20)
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
