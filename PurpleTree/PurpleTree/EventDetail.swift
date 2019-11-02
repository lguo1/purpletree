//
//  EventDetail.swift
//  PurpleTree
//
//  Created by apple on 2019/10/30.
//  Copyright © 2019 purpletree. All rights reserved.
//
import SwiftUI

struct EventDetail: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let ratio: CGFloat = 1.6
    var logo: Image
    var event: Event
    var body: some View {
        VStack{
            event.image
                .resizable()
                .edgesIgnoringSafeArea(.all)
            HStack {
                Group {
                    VStack {
                        Text(event.speaker)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                        Text(event.speakerTitle)
                        HStack {
                            Text(event.day)
                            Spacer()
                            Text(event.date)
                            Spacer()
                            Text(event.time)
                            Spacer()
                        }
                    }
                }
            logo
                .resizable()
                .scale(.medium)
            }
        }
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(logo: Image("logo"),event: eventData[0])
    }
}
