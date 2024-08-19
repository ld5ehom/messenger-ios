//
//  DiskStorage.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import UIKit

/**
 Task 3: Image Cache memory control
 */
protocol DiskStorageType {
    func value(for key: String) throws -> UIImage?
    func store(for key: String, image: UIImage) throws
}

/**
 Implements disk storage for images, saving them to the device's cache directory.
 */
class DiskStorage: DiskStorageType {
    
    // The FileManager instance used for file operations.
    let fileManager: FileManager
    
    // URL of the directory where cached images are stored.
    let directoryURL: URL
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        
        // cache/ImageCache
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("ImageCache")
        
        createDirectory()
    }
    
    /**
     Creates the cache directory if it does not already exist.
     */
    func createDirectory() {
        guard !fileManager.fileExists(atPath: directoryURL.path()) else {
            return
        }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
    }
    
    // Generates the file URL for caching an image with the given key.
    func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    // Retrieves an image from disk storage for the given key.
    func value(for key: String) throws -> UIImage? {
        let fileURL = cacheFileURL(for: key)
        
        // Check if the file exists at the specified URL.
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
    }
    
    // When an image with the given URL is not found in either memory storage or disk storage
    func store(for key: String, image: UIImage) throws {
        let data = image.jpegData(compressionQuality: 0.5)
        let fileURL = cacheFileURL(for: key)
        try data?.write(to: fileURL)
    }
}
