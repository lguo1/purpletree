//
//  Network.swift
//  PurpleTree
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

func requestUpdate(_ location: String, completionHandler: @escaping ([String]?, Error?) -> Void) -> Void {
    guard let url = URL(string: location) else {
           print("Cannot create updateURL")
           return
       }
    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard let data = data else {
           print("No update data")
           completionHandler(nil, error)
           return
        }
        let decoder = JSONDecoder()
        do {
        let update = try decoder.decode([String].self, from: data)
             completionHandler(update, nil)
        } catch {
             print("Decoding failed")
             completionHandler(nil, error)
        }
    }
    task.resume()
}

func requestEvent(_ location: String, completionHandler: @escaping (Event?, Error?) -> Void) -> Void {
    guard let url = URL(string: location) else {
           print("Cannot create eventURL")
           return
       }
    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard let data = data else {
               print("No event data")
               completionHandler(nil, error)
               return
        }
        let decoder = JSONDecoder()
        do {
        let event = try decoder.decode(Event.self, from: data)
             completionHandler(event, nil)
        } catch {
             print("Decoding failed")
             completionHandler(nil, error)
        }
    }
    task.resume()
}


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


func requestImageData(_ location: String, imageName: String, completionHandler: @escaping (Data?, Error?) -> Void) -> Void {
    guard let url = URL(string: location+"img/"+imageName+"/") else {
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
        completionHandler(data, nil)
    }
    task.resume()
}
