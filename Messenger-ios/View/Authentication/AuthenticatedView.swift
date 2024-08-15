//
//  AuthenticatedView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/12/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    
    /*
     * Display either the login view or main tab view based on the authentication state
     */
    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                LoginIntroView()
                    .environmentObject(authViewModel)
            case .authenticated:
                MainTabView()
            }
        }
        .onAppear {
             authViewModel.send(action: .checkAuthenticationState)
        }
    }
}



// Inject Preview serivce
#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService(authService: StubAuthenticationService()))))
}
