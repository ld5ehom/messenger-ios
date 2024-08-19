//
//  HomeViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/15/24.
//

import Foundation
import Combine

// Task 2 Home View Model
class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
        case requestContacts // contact service
        case presentMyProfileView
        case presentOtherProfileView(String) // Includes associated value for passing friend user ID
    }

    // profileView user information
    @Published var myUser: User?
    
    // HomeView Friend list
//    @Published var users: [User] = [.stub1, .stub2] // Dummy data[.stub1, .stub2]
    @Published var users: [User] = []
    
    // General loading phase
    @Published var phase: Phase = .notRequested
    
    // Modal Destination
    @Published var modalDestination: HomeModalDestination?
    
    var userId: String
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    // UserService Firebase getUser data
    init(container: DIContainer, userId: String) {
        self.container = container
        self.userId = userId
    }
    
    // My user setting
    func send(action: Action) {
        switch action {
        case .load:
            // Set the phase to .loading to indicate that a loading process has started
            phase = .loading
            container.services.userService.getUser(userId: userId)
                .handleEvents(receiveOutput: { [weak self] user in
                    self?.myUser = user
                })
                .flatMap { user in
                    self.container.services.userService.loadUsers(id: user.id)
                }
                .sink { [weak self] completion in
                    if case .failure = completion { // Loading failed
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in
                    self?.phase = .success  // Loading succeeded
                    self?.users = users
                }.store(in: &subscriptions)
            
        // Fetch contacts from the contact service
        case .requestContacts:
            container.services.contactService.fetchContacts()
                .flatMap { users in
                    self.container.services.userService.addUserAfterContact(users: users)
                }
            
                // After adding, reload the user information
                .flatMap { _ in
                    self.container.services.userService.loadUsers(id: self.userId)
                }

                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .fail
                    }
                } receiveValue: { [weak self] users in //DB -> Load
                    self?.phase = .success
                    self?.users = users
                }
                .store(in: &subscriptions)
            
        case .presentMyProfileView:
            modalDestination = .myProfile
            
        case let .presentOtherProfileView(userId):
            modalDestination = .otherProfile(userId)
            
        }
    }
}
