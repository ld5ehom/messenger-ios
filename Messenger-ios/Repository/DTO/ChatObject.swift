//
//  ChatObject.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation

/**
 Task 4: Chat Object 
 */
struct ChatObject: Codable {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: TimeInterval
}

extension ChatObject {
    func toModel() -> Chat {
        .init(chatId: chatId,
              userId: userId,
              message: message,
              photoURL: photoURL,
              date: Date(timeIntervalSince1970: date))
    }
}
