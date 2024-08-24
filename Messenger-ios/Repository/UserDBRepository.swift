//
//  UserDBRepository.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

// Task 2 Firebase Realtime DB
import Foundation
import Combine

// Task 2: Adds a new user to the firebase database
protocol UserDBRepositoryType {
    
    // Accepts user information and inserts it into the database
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    
    // Contacts service (add friend list)
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
    
    // Retrieves user information from the database using the provided user ID and returns a UserObject
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    
    // Task 3: MyProfileView. Retrieves user information asynchronously using async/await.
    func getUser(userId: String) async throws -> UserObject
    
    // Retrieves all user information under the "Users" key and returns it as an array.
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    
    func updateUser(userId: String, key: String, value: Any) -> AnyPublisher<Void, DBError>
    
    // Updates the user data in Firebase DB
    func updateUser(userId:String, key: String, value: Any) async throws
    
    // Task 5: Search View
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError>
}

class UserDBRepository: UserDBRepositoryType {
    
    // Firebase Database reference object for accessing the database
//    var db: DatabaseReference = Database.database().reference()
    
    private let reference: DBReferenceType
    
    // Firebase DB referance init
    init(reference: DBReferenceType) {
        self.reference = reference
    }
    
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object -> data -> dic
        // Convert the UserObject into a JSON-encoded Data
        Just(object)
            // Encode user information into Data
            .compactMap { try? JSONEncoder().encode($0) }
        
            // Convert the Data into a dictionary format
            .compactMap { try? JSONSerialization.jsonObject(with:$0, options: .fragmentsAllowed) }
        
            // Save the dictionary to Firebase under the user's ID
            .flatMap { [weak self] value -> AnyPublisher<Void, DBError> in
                guard let `self` = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.reference.setValue(key: DBKey.Users, path: object.id, value: value)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Task 2 - Contacts service: Combines two identical user streams using Zip.
     The first stream encodes the user to JSON, and the second stream decodes the JSON back to an object, then stores it in the Firebase DB.
     */
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError> {
        Publishers.Zip(users.publisher, users.publisher)
            /**
                Users/
                    user_id: [String: Any],
                    user_id: [String: Any],
                    user_id: [String: Any], ...
             */
            // First stream: Encode the user object to JSON
            .compactMap { origin, converted in
                if let converted = try? JSONEncoder().encode(converted) {
                    return (origin, converted)
                } else {
                    return nil //failure
                }
            }
        
            // Second stream: Decode the JSON back into a JSON object
            .compactMap { origin, converted in
                if let converted = try? JSONSerialization.jsonObject(with: converted, options: .fragmentsAllowed) {
                    return (origin, converted)
                } else {
                    return nil
                }
            }
        
            // Interact with the database to store the user data
            .flatMap { [weak self] origin, converted -> AnyPublisher<Void, DBError> in
                guard let `self` = self else {
                    return Empty().eraseToAnyPublisher()
                }
                return self.reference.setValue(key: DBKey.Users, path: origin.id, value: converted)
            }
            .last()  // UI update
            .eraseToAnyPublisher()
    }
    
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        // Firebase DB reference
        reference.fetch(key: DBKey.Users, path: userId)
            .flatMap { value in   // Converts the snapshot value into a UserObject
                if let value {
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0)}
                        .decode(type: UserObject.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    // test case
                    return Fail(error: .emptyValue).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Task 3: Uses Firebase's async support to fetch user data
    func getUser(userId: String) async throws -> UserObject {
        guard let value = try await reference.fetch(key: DBKey.Users, path: userId) else {
            throw DBError.emptyValue
        }
        
        let data = try JSONSerialization.data(withJSONObject: value)
        let userObject = try JSONDecoder().decode(UserObject.self, from: data)
        return userObject
    }
    
    // Updates the user data in Firebase DB
    func updateUser(userId: String, key: String, value: Any) async throws  {
        try await reference.setValue(key: DBKey.Users, path: "\(userId)/\(key)", value: value)
    }
    
    func updateUser(userId: String, key: String, value: Any) -> AnyPublisher<Void, DBError> {
        reference.setValue(key: key, path: "\(userId)/\(key)", value: value)
    }
    
    // Fetches id, name, and profileURL from Firebase's database and returns them as an array of UserObject
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        
        reference.fetch(key: DBKey.Users, path: nil)
            .flatMap { value in
                // Check if the value can be cast to a dictionary of type [String: [String: Any]]
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        // Convert the dictionary to JSON data
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        // Decode the JSON data into a dictionary of [String: UserObject]
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        // Extract the values from the dictionary and convert them into an array of UserObject
                        .map { $0.values.map { $0 as UserObject } }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    // Return an empty array if the data is nil
                    return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
                } else {
                    // Return a failure if the data type is invalid
                    return Fail(error: .invalidatedType).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    /**
     Task 5:Filters users in the database based on the provided query string, retrieving user objects that match the criteria.
     */
    func filterUsers(with queryString: String) -> AnyPublisher<[UserObject], DBError> {
        reference.filter(key: DBKey.Users, path: nil, orderedName: "name", queryString: queryString)
        // [String : [String : Any]
            .flatMap { value in
                if let dic = value as? [String: [String: Any]] {
                    return Just(dic)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: [String: UserObject].self, decoder: JSONDecoder())
                        .map { $0.values.map { $0 as UserObject} }
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else if value == nil {
                    return Just([]).setFailureType(to: DBError.self).eraseToAnyPublisher()
                } else {
                    return Fail(error: .invalidatedType).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}


