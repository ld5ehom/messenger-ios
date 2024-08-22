//
//  UserService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

import Foundation
import Combine

protocol UserServiceType {
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError>
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError>
    func getUser(userId: String) -> AnyPublisher<User, ServiceError>
    func getUser(userId: String) async throws -> User
    func updateDescription(userId: String, description: String) async throws
    func updateProfileURL(userId: String, urlString: String) async throws
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError>
    func filterUsers(with queryString: String, userId: String) -> AnyPublisher<[User], ServiceError>
}

/**
 Task 2 Firebase Realtime DB
 */
class UserService: UserServiceType {
    
    // Injects a UserDBRepository to connect and access the user repository
    private var dbRepository: UserDBRepositoryType
    
    init(dbRepository: UserDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        
        // Calls the UserDBRepository to add a new user
        dbRepository.addUser(user.toObject())
            .map { user }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
        
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        dbRepository.addUserAfterContact(users: users.map { $0.toObject()} )
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        dbRepository.getUser(userId: userId)
            .map { $0.toModel() }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    // MyProfileView firebase async user data (Task 3)
    func getUser(userId: String) async throws -> User {
        let userObject = try await dbRepository.getUser(userId: userId)
        return userObject.toModel()
    }
    
    // Updates the user's status description in Firebase (Task 3)
    func updateDescription(userId: String, description: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "description", value: description)
    }
    
    // Update User profile in Firebase (Task 3)
    func updateProfileURL(userId: String, urlString: String) async throws {
        try await dbRepository.updateUser(userId: userId, key: "profileURL", value: urlString)
    }
    
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.loadUsers()
            .map { $0
                .map { $0.toModel() }
                .filter { $0.id != id }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
    /**
     Task 5: Filters users based on the provided query string and excludes the user with the given userId.
     */
    func filterUsers(with queryString: String, userId: String) -> AnyPublisher<[User], ServiceError> {
        dbRepository.filterUsers(with: queryString)
            .map { $0
                .map { $0.toModel() }
                .filter { $0.id != userId }
            }
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
    
}

class StubUserService: UserServiceType {
    
    func addUser(_ user: User) -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func addUserAfterContact(users: [User]) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<User, ServiceError> {
        // Fetches the friend list for testing
        Just(.stub1).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func getUser(userId: String) async throws -> User {
        return .stub1
    }
    
    func updateDescription(userId: String, description: String) async throws {
            
    }
    
    func updateProfileURL(userId: String, urlString: String) async throws {
        
    }
    
    func loadUsers(id: String) -> AnyPublisher<[User], ServiceError> {
        // Fetches the friend list for testing
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
    
    func filterUsers(with queryString: String, userId: String) -> AnyPublisher<[User], ServiceError> {
        Just([.stub1, .stub2]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}
