//
//  HomeModalDestination.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

import Foundation

enum HomeModalDestination: Hashable, Identifiable {
    case myProfile
    case otherProfile(String) // Receives user ID as a parameter
    case setting
    
    var id: Int {
        hashValue
    }
}
