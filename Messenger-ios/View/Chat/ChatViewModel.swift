//
//  ChatViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import SwiftUI
import PhotosUI
import Combine

/**
 Task 4: chat view model
 */
class ChatViewModel: ObservableObject {
    
    enum Action {
        case load
        case addChat(String)
        case uploadImage(PhotosPickerItem?)
        case pop
    }
    
    @Published var chatDataList: [ChatData] = []
    @Published var myUser: User?
    @Published var otherUser: User?
    @Published var message: String = ""
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            send(action: .uploadImage(imageSelection))
        }
    }
    
    // Identifier for the chat room
    private let chatRoomId: String
    
    private let myUserId: String
    private let otherUserId: String
    
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer, chatRoomId: String, myUserId: String, otherUserId: String) {
        self.container = container
        self.chatRoomId = chatRoomId
        self.myUserId = myUserId
        self.otherUserId = otherUserId
        
        //Test Data
//        updateChatDataList(.init(chatId: "chat1_id", userId: "user1_id", message: "Hi", date: Date()))
//        updateChatDataList(.init(chatId: "chat2_id", userId: "user2_id", message: "Hi", date: Date()))
        
        bind()
    }

    // Binds the chat service to observe new chat messages and updates the chat data list
    func bind() {
        container.services.chatService.observeChat(chatRoomId: chatRoomId)
            .sink { [weak self] chat in
                // Update the chat data list if a new chat is received
                guard let chat else {
                    return
                }
                self?.updateChatDataList(chat)
            }
            .store(in: &subscriptions)
    }

    /**
      When a new chat is received, it adds the chat to the existing chat data list for the corresponding date or creates a new date entry if it doesn't exist.
     */
    func updateChatDataList(_ chat: Chat) {
        let key = chat.date.toChatDataKey
        
        // Check if there is an existing entry for the date.
        if let index = chatDataList.firstIndex(where: { $0.dateStr == key }) {
            chatDataList[index].chats.append(chat)
        } else {
            // If the date does not exist, create a new entry with the chat.
            let newChatData: ChatData = .init(dateStr: key, chats: [chat])
            chatDataList.append(newChatData)
        }
    }
    
    func getDirection(id: String) -> ChatItemDirection {
        myUserId == id ? .right : .left
    }

    /**
     Chats/
        ChatRoomID/
            chatId1/Chat: Date > 2024.8.20
            chatId1/Chat: Date > 2024.8.20
            chatId1/Chat: Date > 2024.8.20  -> 8.20 group ChatData Model
     */
    func send(action: Action) {
        switch action {
            
            // Load user information for both the current user and the friend(other)
        case .load:
            Publishers.Zip(container.services.userService.getUser(userId: myUserId),
                           container.services.userService.getUser(userId: otherUserId))
            .sink { completion in
                
            } receiveValue: { [weak self] myUser, otherUser in
                self?.myUser = myUser
                self?.otherUser = otherUser
            }.store(in: &subscriptions)
            
            // Handles the addition of a new chat message
        case let .addChat(message):
            let chat: Chat = .init(chatId: UUID().uuidString, userId: myUserId, message: message, date: Date())
            
            // Add the new chat to the specified chat room
            container.services.chatService.addChat(chat, to: chatRoomId)
                .flatMap { chat in
                    return self.container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: self.chatRoomId,
                                                                                             myUserId: self.myUserId,
                                                                                             myUserName: self.myUser?.name ?? "",
                                                                                             otherUserId: self.otherUserId,
                                                                                             lastMessage: chat.lastMessage)
                }
                .sink { completion in
                } receiveValue: { [weak self] _ in
                    self?.message = ""
                }.store(in: &subscriptions)
            
            
            /**
             1. data
             2. uploadService -> storage
             3. chat -> add
             */
        case let .uploadImage(pickerItem):
            guard let pickerItem else {
                return
            }
            
            container.services.photoPickerService.loadTransferable(from: pickerItem)
                .flatMap { data in
                    return self.container.services.uploadService.uploadImage(source: .chat(chatRoomId: self.chatRoomId), data: data)
                }
                .flatMap { url in
                    let chat: Chat = .init(chatId: UUID().uuidString, userId: self.myUserId, photoURL: url.absoluteString, date: Date())
                    return self.container.services.chatService.addChat(chat, to: self.chatRoomId)
                }
                .flatMap { chat in
                    return self.container.services.chatRoomService.updateChatRoomLastMessage(chatRoomId: self.chatRoomId,
                                                                                             myUserId: self.myUserId,
                                                                                             myUserName: self.myUser?.name ?? "",
                                                                                             otherUserId: self.otherUserId,
                                                                                             lastMessage: chat.lastMessage)
                }
                .sink { completion in
                    
                } receiveValue: { _ in
                    
                }.store(in: &subscriptions)
            
        case .pop: break
            // TODO
        }
    }
}
