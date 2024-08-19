//
//  MyprofileViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

// Task 3 - Profile View Model
import Foundation
import SwiftUI
import PhotosUI

@MainActor
class MyProfileViewModel: ObservableObject {

    @Published var userInfo: User?
    
    // MyProfileView.descriptionView
    @Published var isPresentedDescEditView: Bool = false
    
    // Photos Picker (Task 3)
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                await updateProfileImage(pickerItem: imageSelection)
            }
        }
    }

    private let userId: String
    
    private let container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    // Fetches user information asynchronously from Firebase
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
    
    // User status description
    func updateDescription(_ description: String) async {
        do {
            try await container.services.userService.updateDescription(userId: userId, description: description)
            userInfo?.description = description
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // User Profile image update
    func updateProfileImage(pickerItem: PhotosPickerItem?) async {
        guard let pickerItem else { return }
        
        do {
            let data = try await container.services.photoPickerService.loadTransferable(from: pickerItem)
            
            // TODO: storage upload
            // TODO: DB update

        } catch {
            print(error.localizedDescription)
        }
    }
}

