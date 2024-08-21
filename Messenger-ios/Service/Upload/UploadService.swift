//
//  UploadService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import Foundation
import Combine

/**
 Firebase DB image upload service
 */
protocol UploadServiceType {
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError>
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL
}

class UploadService: UploadServiceType {
    
    private let provider: UploadProviderType
    
    init(provider: UploadProviderType) {
        self.provider = provider
    }
    
    // Task 4: Uploads an image to a storage service and returns the download URL of the uploaded image
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        
        // Call the upload method on the provider with the source path, image data, and a unique file name
        provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        let url = try await provider.upload(path: source.path, data: data, fileName: UUID().uuidString)
        return url
    }
}

class StubUploadService: UploadServiceType {
    
    func uploadImage(source: UploadSourceType, data: Data) -> AnyPublisher<URL, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func uploadImage(source: UploadSourceType, data: Data) async throws -> URL {
        return URL(string: "")!
    }
}
