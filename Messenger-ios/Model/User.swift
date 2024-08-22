//
//  User.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/14/24.
//

import Foundation

struct User: Identifiable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
    
}

// Converts a User instance to a UserObject instance
extension User {
    func toObject() -> UserObject {
        .init(id: id,
              name: name,
              phoneNumber: phoneNumber,
              profileURL: profileURL,
              description: description
        )
    }
}


//HomeView Friend List dummy data (for test)
extension User {
    static var stub1: User {
        .init(id: "user1_id", name: "Taewook Park")
    }
    
    static var stub2: User {
        .init(id: "user2_id", name: "Teo Taewook Park")
    }
}
