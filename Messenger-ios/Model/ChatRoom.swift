//
//  ChatRoom.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import Foundation

/**
 Task 3: Friend(other) Chat room model
 */
struct ChatRoom: Hashable {
    var chatRoomId: String
    var lastMessage: String?
    var otherUserName: String
    var otherUseId: String
}

extension ChatRoom {
    func toObject() -> ChatRoomObject {
        .init(chatRoomId: chatRoomId,
              lastMessage: lastMessage,
              otherUserName: otherUserName,
              otherUseId: otherUseId)
    }
}

extension ChatRoom {
    static var stub1: ChatRoom {
        .init(chatRoomId: "chatRoom1_id", otherUserName: "Taewook Park", otherUseId: "user1_id")
    }
    
    static var stub2: ChatRoom {
        .init(chatRoomId: "chatRoom2_id", otherUserName: "Teo Park", otherUseId: "user2_id")
    }
}
