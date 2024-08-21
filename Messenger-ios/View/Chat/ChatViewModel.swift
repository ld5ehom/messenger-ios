//
//  ChatViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI

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
        
    }

}
