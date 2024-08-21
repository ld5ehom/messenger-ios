//
//  ChatItemDirection.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import SwiftUI

/**
 Task 4: Chat room message bubble UI
 */
enum ChatItemDirection {
    case left
    case right
    
    var backgroundColor: Color {
        switch self {
        case .left:
            return .uclaGold
        case .right:
            return .lighterBlue
        }
    }
    
    var overlayAlignment: Alignment {
        switch self {
        case .left:
            return .topLeading
        case .right:
            return .topTrailing
        }
    }
    
    var overlayImage: Image {
        switch self {
        case .left:
            return Image(systemName: "bubble.left")
        case .right:
            return Image(systemName: "bubble.right")
        }
    }
}
