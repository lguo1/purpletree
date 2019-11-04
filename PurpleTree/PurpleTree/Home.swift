//
//  Home.swift
//  PurpleTree
//
//  Created by apple on 2019/11/3.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct Home: View {
    var items: [Event]
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(self.items) { event in
                        HomeRow(event: event)
                                .padding()
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
        Home(items: EventData)
    }
}

struct HomeRow: View {
    var event: Event
    var body: some View {
        HStack {
            VStack{
                Text(event.month)
                Text(event.monthday)
            }
            NavigationLink(
            destination: EventDetail(event: event)){HomeItem(event: event)}
        }
    }
}

struct HomeItem: View {
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
