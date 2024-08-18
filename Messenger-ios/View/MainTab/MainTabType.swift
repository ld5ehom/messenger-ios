//
//  MainTabType.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/15/24.
//

import Foundation

// Defined the type for tabs as an enum (MainTabView)
enum MainTabType: String, CaseIterable {
    case home
    case chat
    case phone
    
    // The titles for the tabs are created as computed properties
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .chat:
            return "Chat"
        case .phone:
            return "Phone"
        }
    }
    
    // When fetching image files from Assets
//    func imageName(selected: Bool) -> String {
//        selected ? "\(rawValue)_fill" : rawValue
//    }
    
    
    // When using Xcode's default images
    func imageName(selected: Bool) -> String {
        switch self {
        case .home:
            return selected ? "house.fill" : "house"
        case .chat:
            return selected ? "message.fill" : "message"
        case .phone:
            return selected ? "phone.fill" : "phone"
        }
    }
}

