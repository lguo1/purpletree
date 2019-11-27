//
//  Home.swift
//  PurpleTree
//
//  Created by apple on 2019/11/3.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct Home: View{
    @EnvironmentObject private var userData: UserData
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading){
                    Text("this fall")
                        .padding(.leading,60)
                    ForEach(self.userData.events ?? []) { event in
                        if event.current {
                            HomeRow(event: event).environmentObject(self.userData)
                            .padding(.leading)
                            .padding(.bottom,20)
                            .padding(.trailing)
                        }
                    }
                    Text("in the future")
                        .padding(.leading,60)
                    ForEach(self.userData.events ?? []) { event in
                        if !event.current {
                            HomeRow(event: event).environmentObject(self.userData)
                            .padding(.leading)
                            .padding(.bottom,20)
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
            VStack{
                if event.current {
                        Text(event.month!)
                        Text(event.monthday!)
                    }
                else {
                        Text(event.season)
                        Text(event.year)
                }
            }
            NavigationLink(
            destination: EventDetail(event: event).environmentObject(self.userData)){
                    HomeItem(event: event)
            }
        }
    }
}

struct HomeItem: View{
    var event: Event
    var body: some View {
        event.image
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(
                Color.black.opacity(0.5))
            .frame(height: 155)
            .cornerRadius(10)
            .clipped()
        .overlay(
        Text(event.speaker)
            .font(.title)
            .padding(.leading, 5)
            .padding(.bottom, 5)
            .foregroundColor(.white),
        alignment:.bottomLeading)
    }
}
