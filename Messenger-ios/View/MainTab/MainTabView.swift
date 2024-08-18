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
                        HomeView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
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

//#Preview {
//    let authService = StubAuthenticationService()
//    let container = DIContainer(services: StubService(authService: authService))
//    
//    MainTabView()
//        .environmentObject(container)
//        .environmentObject(AuthenticationViewModel(container: container))
//}

//struct MainTabView_Previews: PreviewProvider {
//    static let container: DIContainer = .stub
//    
//    static var previews: some View {
//        MainTabView()
//            .environmentObject(Self.container)
//            .environmentObject(AuthenticationViewModel(container: Self.container))
//    }
//}

#Preview {
    MainTabView()
}
