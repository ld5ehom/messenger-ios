//
//  AuthenticationService.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

// Add Authentication service protocol and class
protocol AuthenticationServiceType {
    
}

class AuthenticationService: AuthenticationServiceType {
    
}

class StubAuthenticationService: AuthenticationServiceType {
    var authService: AuthenticationServiceType = StubAuthenticationService()
}
