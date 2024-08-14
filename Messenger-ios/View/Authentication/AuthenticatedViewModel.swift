//
//  AuthenticatedViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

// Authentication state -> View Model
enum AuthenticationState {
    case unauthenticated
    case authenticated
}

/*
 * "authenticated" Case
 * Connect to AuthenticatedViewModel to enable service usage
 */
class AuthenticatedViewModel: ObservableObject {
    
    /*
     * Declared as @Published to manage view branching based on authentication state
     */
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    // Access services via DIContainer; inject container into ViewModel
    private var container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
}
