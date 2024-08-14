//
//  AuthenticatedView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/12/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticatedViewModel
    var body: some View {
        
        /*
         * Display either the login view or main tab view based on the authentication state
         */
        switch authViewModel.authenticationState {
        case .unauthenticated:
            // loginView
            LoginIntroView()
        case .authenticated:
            // mainTabView
            MainTabView()
        }

        
    }
}

// Mock implementation of AuthenticationService
class MockAuthenticationService: AuthenticationServiceType {
    // Implement methods and properties defined in AuthenticationServiceType
}

// Inject Preview serivce
#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())))
}


// Use mock service in Preview
//#Preview {
//    AuthenticatedView(authViewModel: .init(container: .init(services: StubService(authService: MockAuthenticationService()))))
//}
