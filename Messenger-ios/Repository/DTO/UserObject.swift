//
//  UserObject.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/16/24.
//

import Foundation

// Task 2: Defines a DTO (Data Transfer Object) for storing user information in the database
struct UserObject: Codable {
    var id: String
    var name: String
    var phoneNumber: String?
    var profileURL: String?
    var description: String?
}

// Creates a function to transform the UserObject into a User
extension UserObject {
    func toModel() -> User {
        .init(id: id,
              name: name,
              phoneNumber: phoneNumber,
              profileURL: profileURL,
              description: description
        )
    }
}
