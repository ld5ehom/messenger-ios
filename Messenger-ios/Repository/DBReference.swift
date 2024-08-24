//
//  DBReference.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/23/24.
//

import Foundation
import Combine
import FirebaseDatabase

/**
 Task 7: Protocol for interacting with Firebase
 */
protocol DBReferenceType {
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError>
    func setValue(key: String, path: String?, value: Any) async throws
    func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError>
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func fetch(key: String, path: String?) async throws -> Any?
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError>
    func childByAutoId(key: String, path: String?) -> String?
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError>
    func removeObservedHandlers()
}

class DBReference: DBReferenceType {
    
    var db: DatabaseReference = Database.database().reference()
    
    var observedHandlers: [UInt] = []
    
    // path function
    private func getPath(key: String, path: String?) -> String {
        if let path {
            return "\(key)/\(path)"
        } else {
            return key
        }
    }
    
    // Sets a value in the Firebase database at the specified path.
    func setValue(key: String, path: String?, value: Any) -> AnyPublisher<Void, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Void, DBError> { [weak self] promise in
            // General.Constant
            self?.db.child(path).setValue(value) { error, _ in
                if let error {
                    promise(.failure(.error(error)))
                } else {
                    promise (.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // Sets a value in the Firebase database asynchronously at the specified path.
    func setValue(key: String, path: String?, value: Any) async throws {
        try await db.child(getPath(key: key, path: path)).setValue(value)
    }
    
    // Sets multiple values in the Firebase database.
    func setValues(_ values: [String: Any]) -> AnyPublisher<Void, DBError> {
        Future<Void, DBError> { [weak self] promise in
            self?.db.updateChildValues(values) { error, _ in
                if let error {
                    promise(.failure(.error(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // getUser 
    func fetch(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        // Connects to the database using a Future to fetch user information and returns a publisher
        return Future<Any?, DBError> { [weak self] promise in
            self?.db.child(path).getData { error, snapshot in
                
                // Filters the value from the snapshot and handles potential errors
                if let error {
                    promise(.failure(.error(error)))
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
        }.eraseToAnyPublisher()
    }
    
    func fetch(key: String, path: String?) async throws -> Any? {
        try await db.child(getPath(key: key, path: path)).getData().value
    }
    
    func filter(key: String, path: String?, orderedName: String, queryString: String) -> AnyPublisher<Any?, DBError> {
        let path = getPath(key: key, path: path)
        
        return Future<Any?, DBError> { [weak self] promise in
            self?.db.child(path)
                .queryOrdered(byChild: orderedName)
                .queryStarting(atValue: queryString)
                .queryEnding(atValue: queryString + "\u{f8ff}")
                .observeSingleEvent(of: .value) { snapshot in
                    promise(.success(snapshot.value))
                }
        }.eraseToAnyPublisher()
    }
    
    func childByAutoId(key: String, path: String?) -> String? {
        db.child(getPath(key: key, path: path)).childByAutoId().key
    }
    
    func observeChildAdded(key: String, path: String?) -> AnyPublisher<Any?, DBError> {
        let subject = PassthroughSubject<Any?, DBError>()
       
        let handler = db.child(getPath(key: key, path: path)).observe(.childAdded) { snapshot in
            subject.send(snapshot.value)
        }
        
        observedHandlers.append(handler)
        
        return subject.eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {
        observedHandlers.forEach {
            db.removeObserver(withHandle: $0)
        }
    }
}
