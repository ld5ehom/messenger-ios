//
//  Chat.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation

/**
 Task 4: Chat View
 */
struct Chat: Hashable, Identifiable  {
    var chatId: String
    var userId: String
    var message: String?
    var photoURL: String?
    var date: Date
    var id: String { chatId }
}
