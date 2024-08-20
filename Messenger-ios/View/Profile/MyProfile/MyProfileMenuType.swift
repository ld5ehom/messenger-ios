//
//  MyProfileMenuType.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import Foundation

enum MyProfileMenuType: Hashable, CaseIterable {
    case studio
    case decorate
    case save
    case story
    
    var description: String {
        switch self {
        case .studio:
            return "Studio"
        case .decorate:
            return "Decorate"
        case .save:
            return "Save"
        case .story:
            return "Story"
        }
    }
    
    // MyProfileView.Assets Image File
//    var imageName: String {
//        switch self {
//        case .studio:
//            return "mood"
//        case .decorate:
//            return "palette"
//        case .save:
//            return "bookmark_profile"
//        case .story:
//            return "play_circle"
//        }
//    }
    
    var imageName: String {
        switch self {
        case .studio:
            return "camera.fill"
        case .decorate:
            return "paintbrush.fill"
        case .save:
            return "bookmark.fill"
        case .story:
            return "play.circle.fill"
        }
    }
    
}
