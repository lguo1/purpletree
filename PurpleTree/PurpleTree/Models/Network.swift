//
//  Network.swift
//  PurpleTree
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

func getEvent(_ location: String, completionHandler: @escaping ([Event]?, Error?) -> Void) -> Void {
    
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
            print("Getting events succeeded")
            completionHandler(eventData, nil)
       } catch {
            print("Decoding failed")
            completionHandler(nil, error)
       }
   }
   task.resume()
}

func post(_ location: String, dic: [String: String], completionHandler: @escaping (String?) -> Void) -> Void {
    guard let url = URL(string: location) else {
        print("Cannot create URL")
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let jsonData = try! JSONSerialization.data(withJSONObject: dic)
    request.httpBody = jsonData
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
        guard let data = data else {
            print("No feedback")
            completionHandler(nil)
            return
        }
        print("Posting succeeded")
        completionHandler(String(decoding: data, as: UTF8.self))
    }
    task.resume()
}

func getString(_ location: String, completionHandler: @escaping (String?) -> Void) -> Void {
    guard let url = URL(string: location) else {
        print("Cannot create URL")
        completionHandler(nil)
        return
    }
    let task = URLSession.shared.dataTask(with: url) {
       (data, response, error) in
       guard let data = data else {
            print("No data")
            completionHandler(nil)
            return
       }
    print("Networking succeeded")
    completionHandler(String(decoding: data, as: UTF8.self))
   }
   task.resume()
}
