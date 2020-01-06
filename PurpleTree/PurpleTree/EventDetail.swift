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
    @State var showingSheet = false
    @State var sheetType = SheetType.organizer
    var event: Event
    @State var subscribed: Bool {
        didSet { UserDefaults.standard.set(subscribed, forKey: event.organizer)
        }
    }
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                DetailImage(event: self.event, screenSize: proxy.size)
                    .environmentObject(self.loader)
                Spacer()
            }
            .overlay(ScrollView(.vertical, showsIndicators: false) {
                Description(showingSheet: self.$showingSheet, sheetType: self.$sheetType, subscribed: self.$subscribed, event:self.event, screenSize: proxy.size)
                    .environmentObject(self.loader)
            })
            .sheet(isPresented: self.$showingSheet) {
                if self.sheetType == .email {
                    Email(subscribed: self.$subscribed, organizer: self.event.organizer)
                } else if self.sheetType == .organizer {
                    Organizer(organizer: self.event.organizer, overview: UserData.shared.overviews[self.event.organizer]!)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct DetailImage: View {
    @EnvironmentObject private var loader: Loader
    var event: Event
    let screenSize: CGSize
    var body: some View {
        Color(red: event.red, green: event.green, blue: event.blue)
        .overlay(
            VStack {
                Image(uiImage: loader.detailImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width)
                Spacer()
                    .frame(height: screenSize.height/4)
            })
    }
}

struct Description: View {
    @State var alert = false
    @State var alertType = AlertType.subscribed
    @EnvironmentObject private var loader: Loader
    @Binding var showingSheet: Bool
    @Binding var sheetType: SheetType
    @Binding var subscribed: Bool
    enum AlertType {
        case subscribed, unsubscribed, subscriptionError, loadingError
    }
    var event: Event
    let screenSize: CGSize
    var organizerButton: some View {
        Button(action: {
            self.getOrganizer()
        }) {
            Text(self.event.organizer)
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
        }
    }
    var subscribeButton: some View {
        Button(action: {
            self.subscribe()
        }) {
            if subscribed {
                Image(systemName: "person.2.filled")
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
                    .environmentObject(loader)
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
                return Alert(title: Text("Error"), message: Text("Cannot subcribe to the mailing list of \(event.organizer) due to an internet problem. Try again later."), dismissButton: .default(Text("OK")))
            case .loadingError:
                return Alert(title: Text("Error"), message: Text("Cannot load information of \(event.organizer). Try again later."), dismissButton: .default(Text("OK")))
            }
        }
    }
    func getOrganizer() {
        if UserData.shared.overviews[event.organizer] != nil {
            self.showingSheet = true
            self.sheetType = .organizer
        } else {
            getString("\(UserData.shared.endPoint)organizer/\(event.organizer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
            {overview in
                if let overview = overview {
                    UserData.shared.overviews[self.event.organizer] = overview
                    UserData.shared.saveOverviews()
                    self.showingSheet = true
                    self.sheetType = .organizer
                } else {
                    self.alertType = .loadingError
                    self.alert = true
                }
            }
        }
    }
    
    func subscribe() {
        if let email = UserDefaults.standard.string(forKey: "email") {
            post("\(UserData.shared.endPoint)subscribe/", dic: ["email": email, "organizer": event.organizer]) {feedback in
                if feedback == "done" {
                    if self.subscribed {
                        self.subscribed = false
                        self.alertType = .subscribed
                        self.alert = true
                    } else {
                        self.subscribed = true
                        self.alertType = .unsubscribed
                        self.alert = true
                    }
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
            Button(action: {
                self.loader.changeInterest.toggle()
            }) {
                VStack{
                    if loader.interest {
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
            .alert(isPresented: $loader.showingAlert) {
            Alert(title: Text("Event Scheduled"), message: Text("Your event has been added to your calendar"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
