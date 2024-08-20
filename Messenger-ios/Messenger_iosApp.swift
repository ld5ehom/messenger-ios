//
//  Messenger_iosApp.swift
//  Messenger-ios
//

import SwiftUI

@main
struct Messenger_iosApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Declared as a StateObject to inject the DIContainer into the environment.
    @StateObject var container: DIContainer = .init(services: Services())
    var body: some Scene {
        WindowGroup {
            
            // Invoke AuthenticatedView
            AuthenticatedView(authViewModel: .init(container: container),
                              navigationRouter: .init()) // Task 3. OtherProfileView
                .environmentObject(container)
        }
    }
}
