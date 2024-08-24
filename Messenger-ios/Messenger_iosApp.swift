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
    
    // Task 6: Setting View appearance
    @AppStorage(AppStorageType.Appearance) var appearanceValue: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    
    var body: some Scene {
        WindowGroup {
            
            // Invoke AuthenticatedView
            AuthenticatedView(authViewModel: .init(container: container))
                .environmentObject(container)
                .onAppear {
                    container.appearanceController.changeAppearance(AppearanceType(rawValue: appearanceValue))
                }
        }
    }
}
