//
//  ChatRoomDBRepository.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import Foundation
import Combine
import FirebaseDatabase

/**
 Task 3: Other(Friend) Chat room DB
 */
protocol ChatRoomDBRepositoryType {
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError>
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError>
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError>
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void, DBError>
}

class ChatRoomDBRepository: ChatRoomDBRepositoryType {
    
    // Firebase Database reference object for accessing the database
    var db: DatabaseReference = Database.database().reference()
    
    // Checks if a chat room exists
    func getChatRoom(myUserId: String, otherUserId: String) -> AnyPublisher<ChatRoomObject?, DBError> {
        
        // Connects to the database using a Future to fetch user information and returns a publisher
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.ChatRooms).child(myUserId).child(otherUserId).getData { error, snapshot in
                
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
        }
        .flatMap { value in   // Converts the snapshot value into a ChatRoomObject
            if let value {
                return Just(value)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0)}
                    .decode(type: ChatRoomObject?.self, decoder: JSONDecoder())
                    .mapError { DBError.error($0) }
                    .eraseToAnyPublisher()
            } else {
                // test case
                return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addChatRoom(_ object: ChatRoomObject, myUserId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.ChatRooms).child(myUserId).child(object.otherUseId).setValue(value) { error, _ in
                        if let error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
            .mapError { DBError.error($0) }
            .eraseToAnyPublisher()
    }
    
    // otherUserId: [String: Any]
    func loadChatRooms(myUserId: String) -> AnyPublisher<[ChatRoomObject], DBError> {
        Future<Any?, DBError> { [weak self] promise in
            self?.db.child(DBKey.ChatRooms).child(myUserId).getData { error, snapshot in
                if let error {
                    promise(.failure(DBError.error(error)))
                } else if snapshot?.value is NSNull{
                    promise(.success(nil))
                } else {
                    promise(.success(snapshot?.value))
                }
            }
        }
        .flatMap { value in
            if let dic = value as? [String: [String: Any]] {
                return Just(dic)
                    .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                    .decode(type: [String: ChatRoomObject].self, decoder: JSONDecoder())
                    .map { $0.values.map { $0 as ChatRoomObject } }
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
    
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void,DBError> {
        Future { [weak self] promise in
            let values = [
                "\(DBKey.ChatRooms)/\(myUserId)/\(otherUserId)/lastMessage" : lastMessage,
                "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/lastMessage" : lastMessage,
                "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/chatRoomId" : chatRoomId,
                "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/otherUserName" : myUserName,
                "\(DBKey.ChatRooms)/\(otherUserId)/\(myUserId)/otherUserId" : myUserId
            ]
            
            self?.db.updateChildValues(values) { error, _ in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .mapError { .error($0) }
        .eraseToAnyPublisher()
    }
    
}
