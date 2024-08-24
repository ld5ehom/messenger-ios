//
//  AuthenticatedView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/12/24.
//

import SwiftUI

struct AuthenticatedView: View {
    
    /**
     Task 7: Test DIContainer
     */
    @EnvironmentObject var container: DIContainer
    
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
                    .environment(\.managedObjectContext, container.searchDataController.persistantContainer.viewContext)
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
             authViewModel.send(action: .checkAuthenticationState)
            
        }
        // Task 6: Setting View
        .preferredColorScheme(container.appearanceController.appearance.colorScheme)
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .stub))
        .environmentObject(DIContainer.stub)
}
