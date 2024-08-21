//
//  NavigationRoutingView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import SwiftUI

/**
 Task 3: Navigation view 
 */
struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case let .chat(chatRoomId, myUserId, otherUserId):
            ChatView(viewModel: .init(container: container, chatRoomId: chatRoomId, myUserId: myUserId, otherUserId: otherUserId))
        case .search:
            SearchView()
        }
    }
}

