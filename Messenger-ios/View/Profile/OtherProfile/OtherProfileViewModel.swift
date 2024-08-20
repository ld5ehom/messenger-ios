//
//  OtherProfileViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import Foundation

/**
 Task 3: Friend(Other) profile view model 
 */
@MainActor
class OtherProfileViewModel: ObservableObject {
    
    @Published var userInfo: User?
    
    private let userId: String
    private let container: DIContainer
    
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    // Asynchronously fetches user information
    func getUser() async {
        if let user = try? await container.services.userService.getUser(userId: userId) {
            userInfo = user
        }
    }
}
