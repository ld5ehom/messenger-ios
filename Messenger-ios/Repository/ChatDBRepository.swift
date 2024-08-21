//
//  ChatDBRepository.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation
import Combine
import FirebaseDatabase

/**
 Task 4: Firebase DB Reference 
 */
protocol ChatDBRepositoryType {
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError>
    func childByAutoId(chatRoomId: String) -> String
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError>
    func updateChatRoomLastMessage(chatRoomId: String, myUserId: String, myUserName: String, otherUserId: String, lastMessage: String) -> AnyPublisher<Void,DBError>
    func removeObservedHandlers()
}

class ChatDBRepository: ChatDBRepositoryType {
    
    var db: DatabaseReference = Database.database().reference()
    
    var observeHandlers: [UInt] = []
    
    func addChat(_ object: ChatObject, to chatRoomId: String) -> AnyPublisher<Void, DBError> {
        Just(object)
            .compactMap { try? JSONEncoder().encode($0) }
            .compactMap { try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed) }
            .flatMap { value in
                Future<Void, Error> { [weak self] promise in
                    self?.db.child(DBKey.Chats).child(chatRoomId).child(object.chatId).setValue(value) { error, _ in
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
    
    func childByAutoId(chatRoomId: String) -> String {
        let ref = db.child(DBKey.Chats).child(chatRoomId).childByAutoId()
        return ref.key ?? ""
    }
    
    /**
     Observes new chat messages in a specified chat room and returns a publisher with the chat object or an error
     */
    func observeChat(chatRoomId: String) -> AnyPublisher<ChatObject?, DBError> {
        let subject = PassthroughSubject<Any?, DBError>()
        
        // Observe child nodes added under Chats/chatroomId in the database
        let handler = db.child(DBKey.Chats).child(chatRoomId).observe(.childAdded) { snapshot in
            subject.send(snapshot.value)
        }
        observeHandlers.append(handler)
        
        return subject
            .flatMap { value in
                if let value {
                    // Convert the snapshot value to JSON data, then decode it to ChatObject
                    return Just(value)
                        .tryMap { try JSONSerialization.data(withJSONObject: $0) }
                        .decode(type: ChatObject?.self, decoder: JSONDecoder())
                        .mapError { DBError.error($0) }
                        .eraseToAnyPublisher()
                } else {
                    // Return nil if the value is not present
                    return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
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
        
    
    func removeObservedHandlers() {
        observeHandlers.forEach {
            db.removeObserver(withHandle: $0)
        }
    }
}
