//
//  Services.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

protocol ServiceType {
    // Add AuthenticationService
    var authService: AuthenticationServiceType { get set }
    
}

class Services: ServiceType {
    // Add AuthenticationService
    var authService: AuthenticationServiceType
    
    
    // Initializer to set Services
    init() {
        self.authService = AuthenticationService()
    }
}

class StubService: ServiceType {
    var authService: AuthenticationServiceType
    
    // Initializer to set authService
    init(authService: AuthenticationServiceType = MockAuthenticationService()) {
        self.authService = authService
    }
}
