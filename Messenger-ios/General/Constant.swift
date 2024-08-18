//
//  Constant.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

// Task 2 Constant
import Foundation

// Constant.DBKey.Users
typealias DBKey = Constant.DBKey
typealias AppStorageType = Constant.AppStorage

enum Constant { }

extension Constant {
    struct DBKey {
        static let Users = "Users"
        static let ChatRooms = "ChatRooms"
        static let Chats = "Chats"
    }
}

extension Constant {
    struct AppStorage {
        static let Appearance = "AppStorage_Appearance"
    }
}
