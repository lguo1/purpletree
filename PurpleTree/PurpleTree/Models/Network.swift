//
//  Network.swift
//  PurpleTree
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

func request(_ location: String, completionHandler: @escaping ([Event]?, Error?) -> Void) -> Void {
    
    guard let url = URL(string: location) else {
        print("Cannot create URL")
        return
    }
    let task = URLSession.shared.dataTask(with: url) {
       (data, response, error) in
       guard let data = data else {
            print("No data")
            completionHandler(nil, error)
            return
       }
       let decoder = JSONDecoder()
       do {
        let eventData = try decoder.decode(Array<Event>.self, from: data)
            print("Networking succeeded")
            completionHandler(eventData, nil)
       } catch {
            print("Decoding failed")
            completionHandler(nil, error)
       }
   }
   task.resume()
}

func propose(_ location: String, proposal: [String: String], completionHandler: @escaping (String?) -> Void) -> Void {
    guard let url = URL(string: location) else {
        print("Cannot create URL")
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let jsonData = try! JSONSerialization.data(withJSONObject: proposal)
    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
        guard let data = data else {
            print("No feedback")
            completionHandler(nil)
            return
        }
        completionHandler(String(data: data, encoding: .utf8))
    }
    task.resume()
}
