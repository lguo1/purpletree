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
                        HomeRow(event: event)
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
    var event: Event
    var body: some View {
        HStack {
            NavigationLink(
            destination: EventDetail(event: event)){
                HomeItem(event: event, image: event.imageHome, observed: event.homeLoader)
            }
        }
    }
}

struct HomeItem: View{
    var event: Event
    @State var image: UIImage
    @ObservedObject var observed: ImageLoader
    var body: some View {
        VStack{
            Color(red: event.red, green: event.green, blue: event.blue)
                .frame(height: 200)
                .cornerRadius(10)
            .overlay(
                HStack {
                    VStack {
                        Spacer()
                        Image(uiImage: image)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 180)
                            .onReceive(observed.didChange) {image in
                            self.image = image
                            }
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
