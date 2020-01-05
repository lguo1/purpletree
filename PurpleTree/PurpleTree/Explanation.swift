//
//  Notification.swift
//  PurpleTree
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

struct Explanation: View {
    @EnvironmentObject var userData: UserData
    @Binding var sheetType: SheetType
    var refreshButton: some View {
        Button(action: {self.userData.get()}) {
            Image(systemName: "arrow.clockwise")
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            .imageScale(.large)
        }
    }
    var addButton: some View {
        Button(action: { self.sheetType = .proposition}){
            Image(systemName: "plus")
            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.6))
            .imageScale(.large)
        }
    }
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("There is no event because of either of two reasons:")
                    .font(.headline)
                    .padding(.bottom, 30)
                HStack {
                    Text("1")
                        .font(.title)
                        .padding(.trailing, 10)
                    Text("You don't have internet connection. Check the internet and tap the refresh button.")
                }
                .padding(.bottom, 30)
                HStack {
                    Text("2")
                        .font(.title)
                        .padding(.trailing, 10)
                    Text("We haven't put out events yet. Stay tuned or create your own event by tapping the add button.")
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text("No Event"))
            .navigationBarItems(trailing: HStack{
                self.refreshButton
                    .padding(.trailing, 5)
                self.addButton})
        }
    }
}
