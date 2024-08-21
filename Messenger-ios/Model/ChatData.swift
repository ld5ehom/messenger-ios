//
//  ChatData.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation

/**
 Task 4: Chat view data model (group)
 */
struct ChatData: Hashable, Identifiable {
    var dateStr: String
    var chats: [Chat]
    var id: String { dateStr }
}
