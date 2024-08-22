//
//  SearchView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import SwiftUI

/**
Task 5: Search View UI
*/
struct SearchView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel: SearchViewModel
    @AccessibilityFocusState var isSearchBarFocused: Bool

    var body: some View {
        VStack {
            topView
 
            List {
                ForEach(viewModel.searchResults) { result in
                    HStack(spacing: 8) {
                        URLImageView(urlString: result.profileURL)
                            .frame(width: 26, height: 26)
                            .clipShape(Circle())
                        Text(result.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.lightestBlue)
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden) // Seperator line
                    .padding(.horizontal, 30)
                }
            }
            .listStyle(.plain)
 
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // Top bar view
    var topView: some View {
        HStack(spacing: 0) {
            
            // Back button
            Button {
                navigationRouter.pop()
            } label: {
                Label("Back", systemImage: "arrow.backward")
            }

            // Search Bar
            SearchBar(text: $viewModel.searchText,
                      shouldBecomeFirstResponder: $viewModel.shouldBecomeFirstResponder) {
            }
            
            // Close X button
            Button {
                viewModel.send(action: .clearSearchText)
            } label: {
                Label("Close", systemImage: "xmark.circle")
            }
        }
        .padding(.horizontal, 20)
    }
    
    
}

#Preview {
    SearchView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user1_id"))
}
