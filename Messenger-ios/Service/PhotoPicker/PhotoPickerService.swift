//
//  PhotoPickerService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import SwiftUI
import PhotosUI
import Combine

enum PhotoPickerError: Error {
    case importFailed
}

protocol PhotoPickerServiceType {
    
    // Load transferable image data from PhotosPickerItem
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
    
    // Task 4: Chat
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError>
}

class PhotoPickerService: PhotoPickerServiceType {
    
    // Loads image data from a PhotosPickerItem and returns it as a Publisher
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Future { promise in
            
            // Attempt to load the selected image as a PhotoImage
            imageSelection.loadTransferable(type: PhotoImage.self) { result in
                switch result {
                case let .success(image):
                    guard let data = image?.data else {
                        promise(.failure(PhotoPickerError.importFailed))
                        return
                    }
                    promise(.success(data))
                case let .failure(error):
                    promise(.failure(error))
                }
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
    
    // Implements the method to load image data from PhotosPickerItem
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
            throw PhotoPickerError.importFailed
        }
        return image.data
    }
}

class StubPhotoPickerService: PhotoPickerServiceType {
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> AnyPublisher<Data, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        return Data()
    }
}

