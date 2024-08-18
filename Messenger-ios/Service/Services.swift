//
//  Services.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

protocol ServiceType {
    // Task 1: Add AuthenticationService
    var authService: AuthenticationServiceType { get set }
    
    // Task 2: Firebase DB user service
    var userService: UserServiceType { get set }
    
    // Task 2: Contact Framework
    var contactService: ContactServiceType { get set }
    
}

class Services: ServiceType {
    var authService: AuthenticationServiceType
    var userService: UserServiceType
    var contactService: ContactServiceType
    
    init() {
        self.authService = AuthenticationService()
        self.userService = UserService(dbRepository: UserDBRepository())
        self.contactService = ContactService()
    }
}

class StubService: ServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
    var userService: UserServiceType = StubUserService()
    var contactService: ContactServiceType = StubContactService()
}
