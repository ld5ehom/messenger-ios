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
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            contentView
            // modal destination
                .fullScreenCover(item: $viewModel.modalDestination) {
                    switch $0 {
                    case .myProfile:
                        MyProfileView()
                    case let .otherProfile(userId):
                        OtherProfileView()
                    case .setting:
                        ErrorView()
//                        SettingView(viewModel: .init())
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


#Preview {
    HomeView(viewModel: .init(container: .init(services: StubService()), userId: "user1_id"))
}
