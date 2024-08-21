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
        case goToChat(User)
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
    private var navigationRouter: NavigationRouter
    private var subscriptions = Set<AnyCancellable>()
    
    // UserService Firebase getUser data
    // Task 3: Added navigation functionality to link to the Search view.
    init(container: DIContainer, navigationRouter: NavigationRouter ,userId: String) {
        self.container = container
        self.navigationRouter = navigationRouter
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
            
            
        // Task 3: Other(Friend) profile view (ChatRoomService)
        case let .goToChat(otherUser):
            
            // Checks if a chat room exists -> Creates one if it doesn't
            // ChatRooms/myUserId/otherUserId
            container.services.chatRoomService.createChatRoomIfNeeded(myUserId: userId, otherUserId: otherUser.id, otherUserName: otherUser.name)
                .sink { completion in
                    
                } receiveValue: { [weak self] chatRoom in
                    // Chat View navigation
                    // Safely unwrapping self using guard to ensure self is still available
                    guard let `self` = self else {
                        return
                    }
                    
                    // Task 4: Adds navigation to the chat view with the necessary parameters
                    self.navigationRouter.push(to: .chat(chatRoomId: chatRoom.chatRoomId,
                                                          myUserId: self.userId,
                                                          otherUserId: otherUser.id))
                }.store(in: &subscriptions)
            
        }
    }
}
