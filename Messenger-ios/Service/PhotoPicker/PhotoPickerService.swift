//
//  PhotoPickerService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import Foundation
import SwiftUI
import PhotosUI

enum PhotoPickerError: Error {
    case importFailed
}

protocol PhotoPickerServiceType {
    
    // Load transferable image data from PhotosPickerItem
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data
}

class PhotoPickerService: PhotoPickerServiceType {
    
    // Implements the method to load image data from PhotosPickerItem
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        guard let image = try await imageSelection.loadTransferable(type: PhotoImage.self) else {
            throw PhotoPickerError.importFailed
        }
        return image.data
    }
}

class StubPhotoPickerService: PhotoPickerServiceType {
    func loadTransferable(from imageSelection: PhotosPickerItem) async throws -> Data {
        return Data()
    }
}

