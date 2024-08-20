//
//  OtherProfileMenuType.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import Foundation

/**
  Task 3: Friend(other) profile view menu
 */
enum OtherProfileMenuType: Hashable, CaseIterable {
    case chat
    case phoneCall
    case videoCall
    
    // Provides a description for each menu type
    var description: String {
        switch self {
        case .chat:
            return "Chat"
        case .phoneCall:
            return "PhoneCall"
        case .videoCall:
            return "VideoCall"
        }
    }
    
    // MyProfileView.Assets Image File
//    var imageName: String {
//        switch self {
//        case .chat:
//            return "sms"
//        case .phoneCall:
//            return "phone_profile"
//        case .videoCall:
//            return "videocam"
//        }
//    }
    
    // Returns the system image name associated with each menu type
    var imageName: String {
        switch self {
        case .chat:
            return "message.fill"
        case .phoneCall:
            return "phone.fill"
        case .videoCall:
            return "video.fill"
        }
    }

}
