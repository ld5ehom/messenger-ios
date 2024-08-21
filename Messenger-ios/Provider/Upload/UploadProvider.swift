//
//  UploadProvider.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import Foundation
import Combine
import FirebaseStorage
import FirebaseStorageCombineSwift

/**
 upload profile image to Firebase Cloud Storage.
 */
enum UploadError: Error {
    case error(Error)
}

protocol UploadProviderType {
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError>
    func upload(path: String, data: Data, fileName: String) async throws -> URL
}

class UploadProvider: UploadProviderType {
    
    // Firebase Storage reference
    let storageRef = Storage.storage().reference()

    // Task 4: Uploads data to a specified path in storage and returns the download URL of the uploaded file
    func upload(path: String, data: Data, fileName: String) -> AnyPublisher<URL, UploadError> {
        let ref = storageRef.child(path).child(fileName)
        
        return ref.putData(data)
            .flatMap { _ in
                ref.downloadURL()
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    // Uploads data to Firebase Storage and returns the download URL asynchronously.
    func upload(path: String, data: Data, fileName: String) async throws -> URL {
        let ref = storageRef.child(path).child(fileName)
        let _ = try await ref.putDataAsync(data)
        let url = try await ref.downloadURL()
        
        return url
    }
}
