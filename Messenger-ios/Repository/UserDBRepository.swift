//
//  UserDBRepository.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

// Task 2 Firebase Realtime DB
import Foundation
import Combine
import FirebaseDatabase

// Task 2: Adds a new user to the firebase database
protocol UserDBRepositoryType {
    
    // Accepts user information and inserts it into the database
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError>
    
    // Retrieves user information from the database using the provided user ID and returns a UserObject
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError>
    
    // Retrieves all user information under the "Users" key and returns it as an array.
    func loadUsers() -> AnyPublisher<[UserObject], DBError>
    
    // Contacts service (add friend list)
    func addUserAfterContact(users: [UserObject]) -> AnyPublisher<Void, DBError>
    
}

class UserDBRepository: UserDBRepositoryType {
    
    // Firebase Database reference object for accessing the database
    var db: DatabaseReference = Database.database().reference()
    
    func addUser(_ object: UserObject) -> AnyPublisher<Void, DBError> {
        // object -> data -> dic
        // Convert the UserObject into a JSON-encoded Data
        Just(object)
            // Encode user information into Data
            .compactMap { try? JSONEncoder().encode($0) }
        
            // Convert the Data into a dictionary format
            .compactMap { try? JSONSerialization.jsonObject(with:$0, options: .fragmentsAllowed) }
        
            // Save the dictionary to Firebase under the user's ID
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in // Users/userID/ ..
                    // General.Constant
                    self?.db.child(DBKey.Users).child(object.id).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }//.eraseToAnyPublisher()
            }
        
            // Map any errors to a custom DBError
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserObject, DBError> {
        
        // Connects to the database using a Future to fetch user information and returns a publisher
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).child(userId).getData { error, snapshot in
                
                // Filters the value from the snapshot and handles potential errors
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    /**
                     Checks if the snapshot value is NSNull, indicating that the user information does not exist in the database. In this case, returns nil since NSNull is not equivalent to nil.
                     */
                    promise(.success(nil))
                } else {
                    // If there is a value present
                    promise(.success(snapshot?.value))
                }
            }
        }.flatMap { value in   // Converts the snapshot value into a UserObject
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
    
    // Fetches id, name, and profileURL from Firebase's database and returns them as an array of UserObject
    func loadUsers() -> AnyPublisher<[UserObject], DBError> {
        
        // Retrieves the data from the Firebase database and constructs an array of user information
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.Users).getData { error, snapshot in
                
                // Check for any errors during data retrieval
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull {
                    // If no data is found (i.e., NSNull), return nil
                    promise(.success(nil))
                } else {
                    // If data is successfully retrieved, return the value
                    promise(.success(snapshot?.value))
                }
            }
            
        }
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
            .flatMap { [weak self] origin, converted in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Users).child(origin.id).setValue(converted) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .last()  // UI update
            .mapError { .error($0) }
            .eraseToAnyPublisher()
    }
}


