//
//  NavigationDestination.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import Foundation

/**
  Task 3: Other(Friend) view navigation
 */
enum NavigationDestination: Hashable {
    case chat(chatRoomId: String, myUserId: String, otherUserId: String)
    case search(userId: String)
}
