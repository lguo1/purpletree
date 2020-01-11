//
//  Home.swift
//  PurpleTree
//
//  Created by apple on 2019/11/3.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI
import Combine

import SwiftUI

struct Home: View {
    @EnvironmentObject var userData: UserData
    @State var showingSheet = false
    @State var sheetType = SheetType.settings
    var settingsButton: some View {
        Button(action: {
            self.showingSheet.toggle()
            self.sheetType = .settings
        }) {
            Image(systemName: "person.crop.circle")
                .foregroundColor(Color.black)
                .imageScale(.large)
                .accessibility(label: Text("Settings"))
        }
    }
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if self.userData.eventData.count == 0 {
                            NoEvent(showingSheet: self.$showingSheet, sheetType: self.$sheetType, screenSize: proxy.size)
                            .padding(.bottom, 20)
                        } else {
                            ForEach(self.userData.sorted) { event in
                                HomeRow(event: event, screenSize: proxy.size)
                                .environmentObject(self.userData)
                                .padding(.bottom, 20)
                            }
                            AddEvent(showingSheet: self.$showingSheet, sheetType: self.$sheetType, screenSize: proxy.size)
                            .padding(.bottom, 20)
                        }
                            
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .navigationBarTitle(
                Text("PURPLETREE")
                    .font(.title)
                    .fontWeight(.heavy))
                .navigationBarItems(trailing: self.settingsButton)
                .sheet(isPresented: self.$showingSheet) {
                    if self.sheetType == .settings {
                        Settings(sheetType: self.$sheetType)
                        .environmentObject(self.userData)
                    } else if self.sheetType == .proposition {
                        Proposition()
                    } else if self.sheetType == .explanation {
                        Explanation(sheetType: self.$sheetType)
                        .environmentObject(self.userData)
                    } else if self.sheetType == .feedback {
                        Feedback()
                    }
                }
            }
        }
    }
}

struct AddEvent: View {
    @Binding var showingSheet: Bool
    @Binding var sheetType: SheetType
    let screenSize: CGSize
    var body: some View {
    VStack{
        Button(action: { self.showingSheet.toggle()
            self.sheetType = .proposition
        }) {
            Color(red: 0.6, green: 0.4, blue: 0.6)
            .frame(height: screenSize.height/12)
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(
                Image(systemName: "plus")
                .foregroundColor(Color.white)
                .imageScale(.large))
                .accessibility(label: Text("Add Event"))
            }
        }
    }
}

struct NoEvent: View {
    @Binding var showingSheet: Bool
    @Binding var sheetType: SheetType
    let screenSize: CGSize
    var body: some View {
        HStack {
            Button(action: { self.showingSheet.toggle()
                self.sheetType = .explanation
            }){
                Color(red: 0.6, green: 0.4, blue: 0.6)
                .frame(height: screenSize.height/12)
                .cornerRadius(10)
                .shadow(radius: 5)
                .overlay(
                    Image(systemName: "exclamationmark")
                    .foregroundColor(Color.white)
                    .imageScale(.large))
                    .accessibility(label: Text("No Event"))
            }
        }
    }
}


struct HomeRow: View{
    @EnvironmentObject var userData: UserData
    var event: Event
    let screenSize: CGSize
    var body: some View {
        NavigationLink(destination: EventDetail(event: event)) {
            VStack{
                Color(red: event.red, green: event.green, blue: event.blue)
                    .frame(height: screenSize.height/4)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                .overlay(
                    HStack {
                        VStack {
                            Spacer()
                            Image(uiImage: userData.imageData[event.id]![0] ?? UIImage())
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
                        Text(userData.eventData[event.id]!.speakerHome)
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

enum SheetType {
   case settings, proposition, explanation, email, organizer, feedback
}
