//
//  MemoryStorage.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import UIKit

/**
 A protocol defining methods for in-memory image caching.
 */
protocol MemoryStorageType {
    // Retrieves an image from the cache for the specified key.
    func value(for key: String) -> UIImage?
    
    // Stores an image in the cache with the specified key.
    func store(for key: String, image: UIImage)
}

/**
 A class that implements in-memory caching for images using `NSCache`.
 */
class MemoryStorage: MemoryStorageType {
    
    var cache = NSCache<NSString, UIImage>()
    
    func value(for key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key) /*, cost: Image Memory control */ )
    }
}
