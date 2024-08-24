//
//  ChatListView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/15/24.
//

import SwiftUI

// Task 3: Chat List View UI Update
struct ChatListView: View {
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: ChatListViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            ScrollView {
                NavigationLink(value: NavigationDestination.search(userId: viewModel.userId)) {
                    SearchButton()
                }
                .padding(.top, 14)
                .padding(.bottom, 14)
                
                ForEach(viewModel.chatRooms, id: \.self) { chatRoom in
                    // Cell View
                    ChatRoomCell(chatRoom: chatRoom, myUserId: viewModel.userId)
                }
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
            .onAppear {
                viewModel.send(action: .load)
            }
        }
    }
}

// Chat Cell View
fileprivate struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    let myUserId: String
    
    var body: some View {
        NavigationLink(value: NavigationDestination.chat(chatRoomId: chatRoom.chatRoomId,
                                                                 myUserId: myUserId,
                                                                 otherUserId: chatRoom.otherUseId)) {
            HStack(spacing: 8) {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 4) {
                    Text(chatRoom.otherUserName)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.uclaBlue)
                    if let lastMessage = chatRoom.lastMessage {
                        Text(lastMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 17)
        }
    }
}


#Preview {
    ChatListView(viewModel: .init(container: .stub, userId: "user1_id"))
        .environmentObject(DIContainer.stub)
}
