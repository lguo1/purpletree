//
//  Network.swift
//  PurpleTree
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 purpletree. All rights reserved.
//

import SwiftUI

func post(_ location: String, dic: [String: String], completionHandler: @escaping (String?) -> Void) -> Void {
    let url = URL(string: location)!
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

func getEventData(_ location: String, completionHandler: @escaping ([String: Event]?) -> Void) -> Void {
    let url = URL(string: location)!
    let task = URLSession.shared.dataTask(with: url) {
       (data, response, error) in
       guard let data = data else {
            print("No data")
            completionHandler(nil)
            return
       }
       let decoder = JSONDecoder()
       do {
        let eventData = try decoder.decode([String: Event].self, from: data)
            print("Got eventData")
            completionHandler(eventData)
       } catch {
            print("Events decoding failed")
            completionHandler(nil)
       }
   }
   task.resume()
}

func getOrganizerData(_ location: String, completionHandler: @escaping ([String: Organizer]?) -> Void) -> Void {
    let url = URL(string: location)!
    let task = URLSession.shared.dataTask(with: url) {
       (data, response, error) in
       guard let data = data else {
            print("No data")
            completionHandler(nil)
            return
       }
       let decoder = JSONDecoder()
       do {
        let organizerData = try decoder.decode([String: Organizer].self, from: data)
            print("Got organizerData")
            completionHandler(organizerData)
       } catch {
            print("Organizer decoding failed")
            completionHandler(nil)
       }
   }
   task.resume()
}

func getImage(_ endPoint: String, imageName: String, completionHandler: @escaping (UIImage?) -> Void) -> Void {
    let url = URL(string: "\(endPoint)img/\(imageName)/")!
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completionHandler(nil)
            print("No data for \(imageName)")
            return
        }
        guard let image = UIImage(data: data) else {
            completionHandler(nil)
            print("Cannot decode \(imageName)")
            return
        }
        saveImage(image, imageName: imageName)
        completionHandler(image)
        print("Got \(imageName)")
    }
    task.resume()
}

func saveImage(_ image: UIImage, imageName: String) -> Void {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let imageHomeURL = documentsDirectory.appendingPathComponent(imageName)
    do {
        try image.pngData()!.write(to: imageHomeURL)
        print("Saved \(imageName)")
    } catch {
        print("Couldn't save \(imageName)")
    }
}
