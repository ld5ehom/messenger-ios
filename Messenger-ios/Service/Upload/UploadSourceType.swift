//
//  UploadSourceType.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import Foundation

/**
 Task 3: Enum to manage upload paths for Firebase DB.
 */
enum UploadSourceType {
    case chat(chatRoomId: String)
    case profile(userId: String)
    
    // Returns the path in Firebase DB based on the upload source type.
    var path: String {
        switch self {
            
        // Chats/chatRoomID
        case let .chat(chatRoomId):
            return "\(DBKey.Chats)/\(chatRoomId)"
            
        // Users/UserID/
        case let .profile(userId):
            return "\(DBKey.Users)/\(userId)"
        }
    }
}
