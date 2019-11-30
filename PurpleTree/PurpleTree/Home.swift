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
                    ForEach(self.userData.events) {event in
                        HomeRow(event: event).environmentObject(self.userData)
                            .padding(.leading)
                            .padding(.bottom,20)
                            .padding(.trailing)
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct HomeRow: View {
    @EnvironmentObject private var userData: UserData
    var event: Event
    var body: some View {
        HStack {
            NavigationLink(
            destination: EventDetail(event: event)){
                HomeItem(event: event, imageLoader: event.homeLoader, image: event.homeLoader.image).environmentObject(self.userData)
            }
        }
    }
}

struct HomeItem: View{
    @EnvironmentObject private var userData: UserData
    var event: Event
    var eventIndex: Int {
        userData.events.firstIndex(where: { $0.id == event.id })!
    }
    @ObservedObject var imageLoader = userData.events[eventIndex].homeLoader
    @State var image: UIImage
    var body: some View {
        VStack{
            Color(red: event.red, green: event.green, blue: event.blue)
                .frame(height: 200)
                .cornerRadius(10)
            .overlay(
                HStack {
                    VStack{
                        Spacer()
                        Image(uiImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 180)
                        .onReceive(imageLoader.didChange, perform: { (image) in
                            self.image = image
                        })
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
                    Spacer()
                }
            })
        }
    }
}
