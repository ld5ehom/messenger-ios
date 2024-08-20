//
//  HomeView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/15/24.
//

import SwiftUI

// Task 2 Home view
struct HomeView: View {
    @EnvironmentObject var container: DIContainer
    
    // Task 3: OtherProfileView Navigation Router
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        // Task 3: Using the navigation router to manage the navigation path in OtherProfileView
        NavigationStack(path: $navigationRouter.destinations) {
            contentView
            // modal destination
                .fullScreenCover(item: $viewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        // Updates performed in Task 3 - My Profile View
                        MyProfileView(viewModel: .init(container: container, userId: viewModel.userId))
                    case let .otherProfile(userId):
                        // Updates performed in Task 3 - Other(friend) Profile View
                        OtherProfileView(viewModel: .init(container: container, userId: userId)) { otherUserInfo in
                            viewModel.send(action: .goToChat(otherUserInfo))
                        }
                    case .setting:
                        ErrorView()
//                        SettingView(viewModel: .init())
                    }
                }
                /**
                 Task 3:OtherProfileView/ Adds a destination modifier to manage the views that are pushed onto the navigation stack
                 */
                .navigationDestination(for: NavigationDestination.self) {
                    switch $0 {
                    case .chat:
                        ChatView()
                    case .search:
                        SearchView()
                    }
                }
            
        }
    }
    
    /**
     General.Phase loading view
     */
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            PlaceholderView()
                 // Calls the `getUser` method from `HomeViewModel`
                .onAppear() {
                    viewModel.send(action: .load)
                }
        case .loading:
            LoadingView()
        case .success:
            loadedView
                // Top-right toolbar (setting)
                .toolbar {
                    Image(systemName: "bookmark.fill")
                    Image(systemName: "bell.fill") // for notifications
                    Image(systemName: "person.crop.circle.badge.plus") // for adding a person
                    Button {
                        // TODO:
                    } label: {
                        Image(systemName: "gearshape.fill") // for settings
                    }
                }
        case .fail:
            ErrorView()
        }
    }
    
    var loadedView: some View {
        ScrollView {
            profileView
                .padding(.bottom, 30)
            
            searchButton
                .padding(.bottom, 20)
            
            HStack {
                Text("Friends")
                    .font(.system(size: 14))
                    .foregroundStyle(.uclaBlue)
                Spacer()
            }
            .padding(.horizontal, 30)
            
            //Friend List
            if viewModel.users.isEmpty {
                // No friends -> show emptyView
                Spacer(minLength: 89)
                emptyView
            } else {
                LazyVStack {
                    ForEach(viewModel.users, id: \.id) { user in
                        Button {
                            viewModel.send(action: .presentOtherProfileView(user.id))
                        } label: {
                            HStack(spacing: 8) {
                                // friends profile image
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                Text(user.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.uclaBlue)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                }
            }
        }
    }
    
    /**
      Main-Center profile view
     */
    var profileView: some View {
        HStack {
            
            // User Information (HomeViewModel)
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.myUser?.name ?? "Name")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.uclaBlue)
                Text(viewModel.myUser?.description ?? "Enter status message")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Personal Profile Image
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .padding(.horizontal, 30)
        .onTapGesture {
            viewModel.send(action: .presentMyProfileView)
        }
    }
    
    /**
      Search Button bar view
     */
    var searchButton: some View {
        /**
         Task 3: OtherProfileView
         Navigates to the Search view when the search button is tapped in OtherProfileView
         */
        NavigationLink(value: NavigationDestination.search) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 36)
                    .background(Color.lightestBlue)
                    .cornerRadius(5)
                
                HStack {
                    Text("Search")
                        .font(.system(size: 12))
                        .foregroundColor(.uclaBlue)
                    Spacer()
                }
                .padding(.leading, 22)
            }
            .padding(.horizontal, 30)
        }
    }
    
    /**
        View displayed when the user has no friends
     */
    var emptyView: some View {
        VStack {
            VStack(spacing: 3) {
                Text("Add a friend.")
                    .foregroundColor(.uclaBlue)
                Text("Use QR code or search to add a friend.")
                    .foregroundColor(.lighterBlue)
            }
            .font(.system(size: 14))
            .padding(.bottom, 30)
            
            Button {
                viewModel.send(action: .requestContacts)
            } label: {
                Text("New friend")
                    .font(.system(size: 14))
                    .foregroundColor(.uclaBlue)
                    .padding(.vertical, 9)
                    .padding(.horizontal, 24)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.uclaBlue)
            }
        }
    }
}

//#Preview {
//    // Initialize the DIContainer and NavigationRouter instances
//    let container = DIContainer(services: StubService())
//    let navigationRouter = NavigationRouter()
//    
//    // Create the HomeView with the view model
//    HomeView(viewModel: HomeViewModel(container: container, navigationRouter: navigationRouter, userId: "user1_id"))
//        .environmentObject(container)
//        .environmentObject(navigationRouter)
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Initialize DIContainer and NavigationRouter instances
        let container = DIContainer(services: StubService())
        let navigationRouter = NavigationRouter()
        
        // Create the HomeView with the view model
        HomeView(viewModel: HomeViewModel(container: container, navigationRouter: navigationRouter, userId: "user1_id"))
            .environmentObject(container)
            .environmentObject(navigationRouter)
    }
}
