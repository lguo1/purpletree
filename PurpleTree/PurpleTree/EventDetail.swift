//
//  EventDetail.swift
//  PurpleTree
//
//  Created by apple on 2019/11/2.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct EventDetail: View {
    @EnvironmentObject var userData: UserData
    @State var showingSheet = false
    @State var sheetType = SheetType.organizer
    var event: Event
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                ImageDetail(event: self.event, screenSize: proxy.size)
                    .environmentObject(self.userData)
                Spacer()
            }
            .overlay(ScrollView(.vertical, showsIndicators: false) {
                Description(showingSheet: self.$showingSheet, sheetType: self.$sheetType, event:self.event, screenSize: proxy.size)
                    .environmentObject(self.userData)
            })
            .sheet(isPresented: self.$showingSheet) {
                if self.sheetType == .email {
                    Email(organizer: self.userData.organizerData[self.event.organizer]!)
                        .environmentObject(self.userData)
                } else if self.sheetType == .organizer {
                    OrganizerDetail(organizer: self.userData.organizerData[self.event.organizer]!)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}
struct ImageDetail: View {
    @EnvironmentObject var userData: UserData
    var event: Event
    let screenSize: CGSize
    var body: some View {
        Color(red: event.red, green: event.green, blue: event.blue)
        .overlay(
            VStack {
                Image(uiImage: userData.imageData[event.id]![1] ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width)
                Spacer()
                    .frame(height: screenSize.height/4)
            })
    }
}

struct SpeakerDescription: View {
    @EnvironmentObject var userData: UserData
    @State var showingAlert = false
    
    var likeButton: some View {
        Button(action: {
            self.changeInterest()
        }) {
            VStack{
                if userData.eventData[event.id]!.interest {
                    Image("logo")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .padding()
                    .animation(.easeIn)
                } else {
                    Text("Like")
                    .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
                    .padding()
                }
            }
        }
    }
    
    var event: Event
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Group {
                Text(event.speaker)
                    .font(.title)
                    .padding(.bottom, 10)
                Text(event.speakerTitle)
                HStack(alignment: .top) {
                    Group {
                        Text(event.date)
                        Text(event.time)
                    }
                }
                Text(event.location)
                }
                .padding(.trailing)
                .padding(.leading)
                
            }
            Spacer()
            likeButton
        }
        .alert(isPresented: $showingAlert) {
        Alert(title: Text("Event Scheduled"), message: Text("Your event has been added to your calendar"), dismissButton: .default(Text("OK")))
        }
    }
    func changeInterest() {
        self.userData.eventData[self.event.id]!.interest.toggle()
        if self.userData.eventData[self.event.id]!.interest && self.event.decided {
            scheduleNotification(title: self.event.speaker, body: "Will begin at \(self.event.location) in 5 mins.", start: self.event.start)
            if self.userData.prefersCalendar {
                addToCalendar(id: self.event.id, speaker: self.event.speaker, start: self.event.start, end: self.event.end, location: self.event.location)
            }
        }
    }
}

struct Description: View {
    @State var alert = false
    @State var alertType = AlertType.subscribed
    @EnvironmentObject var userData: UserData
    @Binding var showingSheet: Bool
    @Binding var sheetType: SheetType
    var event: Event
    let screenSize: CGSize
    
    enum AlertType {
        case subscribed, unsubscribed, subscriptionError
    }
    var organizerButton: some View {
        Button(action: {
            self.showingSheet = true
            self.sheetType = .organizer
        }) {
            Text(self.event.organizer)
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
        }
    }
    var subscribeButton: some View {
        Button(action: {
            self.subscribe()
        }) {
            if userData.organizerData[event.organizer]!.subscribed {
                Image(systemName: "person.2.fill")
                .foregroundColor(.black)
            } else {
                Image(systemName: "person.2")
                .foregroundColor(.black)
            }
        }
    }
    var body: some View {
        VStack {
            Spacer()
                .frame(height: screenSize.height/2)
            VStack(alignment: .leading){
                SpeakerDescription(event: event)
                    .environmentObject(userData)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                Text(event.description)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom, 30)
                Spacer()
                HStack {
                    Text("Presented by")
                        .padding(.trailing, 3)
                    organizerButton
                        .padding(.trailing, 3)
                    subscribeButton
                }
                .padding(.leading)
                .padding(.trailing)
            }
            .background(
                Color(.white)
                .frame(height: screenSize.height*2)
                .cornerRadius(10)
                .shadow(radius: 5)
                , alignment: .top
            )
        }
        .alert(isPresented: $alert) {
            switch alertType {
            case .subscribed:
                return Alert(title: Text("Subscribed"), message: Text("Thank you for joining the mailing list of \(event.organizer)."), dismissButton: .default(Text("Welcome")))
            case .unsubscribed:
                return Alert(title: Text("Unsubscribed"), message: Text("You have unsubscribed from \(event.organizer)."), dismissButton: .default(Text("OK")))
            case .subscriptionError:
                return Alert(title: Text("Failed"), message: Text("Cannot join the mailing list of \(event.organizer) due to an internet problem. Try again later."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func subscribe() {
        if let email = UserDefaults.standard.string(forKey: "Email") {
            post("\(UserData.shared.endPoint)subscribe/", dic: ["email": email, "organizer": event.organizer]) {feedback in
                if feedback == "done" {
                    let old = self.userData.organizerData[self.event.organizer]!.subscribed
                   DispatchQueue.main.async {
                    self.userData.organizerData[self.event.organizer]!.subscribed = !old
                    }
                    if old {
                        self.alertType = .unsubscribed
                    } else {
                        self.alertType = .subscribed
                    }
                    self.alert = true
                } else {
                    self.alertType = .subscriptionError
                    self.alert = true
                }
            }
        } else {
            self.sheetType = .email
            self.showingSheet = true
        }
    }
}

