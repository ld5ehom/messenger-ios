//
//  ChatService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation
import Combine
 
protocol ChatServiceType {
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError>
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never>
    func removeObservedHandlers()
}

class ChatService: ChatServiceType {
    
    private let dbRepository: ChatDBRepositoryType
    
    init(dbRepository: ChatDBRepositoryType) {
        self.dbRepository = dbRepository
    }
    
    // Adds a chat to the specified chat room and returns a publisher with the added chat or an error
    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        var chat = chat
        chat.chatId = dbRepository.childByAutoId(chatRoomId: chatRoomId)
        
        return dbRepository.addChat(chat.toObject(), to: chatRoomId)
            .map { chat }
            .mapError { ServiceError.error($0) }
            .eraseToAnyPublisher()
    }
    
    // Observes chat updates for the specified chat room and returns a publisher with the updated chat or nil
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        dbRepository.observeChat(chatRoomId: chatRoomId)
            .map { $0?.toModel() }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    // Removes all
    func removeObservedHandlers() {
        dbRepository.removeObservedHandlers()
    }
}

class StubChatService: ChatServiceType {

    func addChat(_ chat: Chat, to chatRoomId: String) -> AnyPublisher<Chat, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func observeChat(chatRoomId: String) -> AnyPublisher<Chat?, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func removeObservedHandlers() {

    }
}
