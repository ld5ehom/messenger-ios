//
//  AuthenticatedView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/12/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @StateObject var authViewModel: AuthenticationViewModel
    
    /**
     Task 3: OtherProfileView/Added a NavigationRouter to inject into the MainTabView
     */
    @StateObject var navigationRouter: NavigationRouter
    
    /**
     Task 5: Search Core data
     */
    @StateObject var searchDataController: SearchDataController
    
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
                    .environment(\.managedObjectContext, searchDataController.persistantContainer.viewContext)
                    .environmentObject(authViewModel)
                    .environmentObject(navigationRouter)
            }
        }
        .onAppear {
             authViewModel.send(action: .checkAuthenticationState)
            
        // Calls the logout method to proceed with logging out

        }
    }
}

#Preview {
    AuthenticatedView(authViewModel: .init(container: .init(services: StubService())),
                      navigationRouter: .init(),
                      searchDataController: .init())
                    
}
