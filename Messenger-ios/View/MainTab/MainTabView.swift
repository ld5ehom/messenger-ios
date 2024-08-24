//
//  MainTabView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import SwiftUI

// Task 2 Home View 
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        // Injects the user ID
                        // Task 3: Using the navigation router to manage the navigation path in OtherProfileView
                        HomeView(viewModel: .init(container: container,  userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
                    case .phone:
                        Text("Taewook Park")
                    }
                }
                
                // Assets images
//                .tabItem {
//                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
//                }
                
                // Xcode System image
                .tabItem {
                    Label(tab.title, systemImage: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        
        // Changes color when clicked
        .tint(.uclaGold)
    }
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.uclaBlue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(DIContainer.stub)
        .environmentObject(AuthenticationViewModel(container: .stub))
}
