//
//  ImageStore.swift
//  PurpleTree
//
//  Created by apple on 2019/11/27.
//  Copyright © 2019 purpletree. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation

final class ImageStore {
    typealias _ImageDictionary = [String: UIImage?]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> UIImage? {
        let index = _guaranteeImage(name: name)
        return images.values[index]
    }

    static func loadImage(name: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        guard let image = UIImage(contentsOfFile: fileURL.path)
            else {
                return nil
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}
