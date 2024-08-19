//
//  PhotoImage.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import SwiftUI

// PhotoImage struct conforms to Transferable for handling image data transfer
struct PhotoImage: Transferable {
    
    let data: Data
    
    // TransferRepresentation for importing image data
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            
            // Convert Data to UIImage
            guard let uiImage = UIImage(data: data) else {
                throw PhotoPickerError.importFailed
            }
            
            guard let data = uiImage.jpegData(compressionQuality: 0.3) else {
                throw PhotoPickerError.importFailed
            }
            
            return PhotoImage(data: data)
        }
    }
}
