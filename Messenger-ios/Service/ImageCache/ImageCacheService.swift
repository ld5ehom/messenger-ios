//
//  ImageCacheService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import UIKit
import Combine

/**
 Task 3: Service responsible for image caching to manage memory
 */
protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

class ImageCacheService: ImageCacheServiceType {
    
    let memoryStorage: MemoryStorageType
    let diskStorage: DiskStorageType
    
    init(memoryStorage: MemoryStorageType, diskStorage: DiskStorageType) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    /**
     1. Memory storage
     2. Disk storage
     3. URL session -> memory and disk storage
     */
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        imageWithMemoryCache(for: key)
            .flatMap { image -> AnyPublisher<UIImage?, Never> in
                
                if let image {
                    return Just(image).eraseToAnyPublisher()
                } else {  // empty -> Disk
                    return self.imageWithDiskCache(for: key)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // 1. Memory storage
    func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image = self?.memoryStorage.value(for: key)
            promise(.success(image))
        }.eraseToAnyPublisher()
    }
    
    // 2. Disk storage
    func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image = try self?.diskStorage.value(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        // Check if the image exists in disk storage
        .flatMap { image -> AnyPublisher<UIImage?, Never> in
            if let image {
                return Just(image)
                    .handleEvents(receiveOutput: { [weak self] image in
                        guard let image else {
                            return
                        }
                        self?.store(for: key, image: image, toDisk: false)
                    })
                    .eraseToAnyPublisher()
            } else {
                // 3. URL network
                return self.remoteImage(for: key)
            }
        }
        .eraseToAnyPublisher()
    }
    
    // 3. URL network session -> memory and disk storage
    func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
        
            // Convert the received data into a UIImage object
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image else {
                    return
                }
                self?.store(for: urlString, image: image, toDisk: true)
            })
            .eraseToAnyPublisher()
    }
    
    // Stores an image in memory and optionally in disk storage.
    func store(for key: String, image: UIImage, toDisk: Bool) {
        memoryStorage.store(for: key, image: image)
        
        if toDisk {
            try? diskStorage.store(for: key, image: image)
        }
    }
}


class StubImageCacheService: ImageCacheServiceType {
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
}
