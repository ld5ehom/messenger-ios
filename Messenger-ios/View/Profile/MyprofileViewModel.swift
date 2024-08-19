//
//  MyprofileViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

// Task 3 - Profile View Model
import Foundation

@MainActor
class MyProfileViewModel: ObservableObject {

    @Published var userInfo: User?
    
    // MyProfileView.descriptionView
    @Published var isPresentedDescEditView: Bool = false
    
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
    
}

