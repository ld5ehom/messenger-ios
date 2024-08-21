//
//  ChatView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import SwiftUI

/**
 Task 4: Chat View UI
 */
struct ChatView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel: ChatViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        // Top Menu UI
        ScrollViewReader { proxy in
            ScrollView {
                if viewModel.chatDataList.isEmpty {
                    Color.lightestBlue
                } else {
                    contentView
                }
            }
        }
        .background(Color.lightestBlue)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.lightestBlue, for: .navigationBar) // scroll background 
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    navigationRouter.pop()
                } label: {
                    Image(systemName: "chevron.left") // System image for back button
                        .accessibilityLabel(Text("Back"))
                }
                
                // Other(Friend) User Name
                Text(viewModel.otherUser?.name ?? "Chat Room Name")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.uclaBlue)
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Image(systemName: "magnifyingglass") // System image for search
                    .accessibilityLabel(Text("Search"))
                Image(systemName: "bookmark") // System image for bookmark
                    .accessibilityLabel(Text("Bookmark"))
                Image(systemName: "gear") // System image for settings
                    .accessibilityLabel(Text("Settings"))
            }
        }
        .keyboardToolbar(height: 50) {
            HStack(spacing: 13) {
                
                // + More Button
                Button {
                } label: {
                    Image(systemName: "ellipsis.circle") // "other_add"
                        .accessibilityLabel(Text("More"))
                }


                // Photo Camera Button
                Button {
                } label: {
                    Image(systemName: "camera") // "photo_camera"
                        .accessibilityLabel(Text("Camera"))
                }
                
                TextField("", text: $viewModel.message)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .focused($isFocused)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 13)
                    .background(Color.lightestBlue)
                    .cornerRadius(20)
                
                // Send Button
                Button {
                    viewModel.send(action: .addChat(viewModel.message))
                    isFocused = false
                } label: {
                    Image(systemName: "paperplane.fill") // "send"
                        .accessibilityLabel(Text("Send"))
                }
                .disabled(viewModel.message.isEmpty)
            }
            .padding(.horizontal, 27)
        }
        .onAppear {
            viewModel.send(action: .load)
        }
    }
    
    // Scroll Content View (ChatRoom Message)
    var contentView: some View {
        ForEach(viewModel.chatDataList) { chatData in
            Section {
                ForEach(chatData.chats) { chat in
                    ChatItemView(message: chat.message ?? "",
                                 direcion: viewModel.getDirection(id: chat.userId),
                                 date: chat.date)
                }
            } header: {
                headerView(dateStr: chatData.dateStr)
            }
        }
    }

    // Creates a header view with the provided date string.
    func headerView(dateStr: String) -> some View {
         ZStack {
             Rectangle()
                 .foregroundColor(.clear)
                 .frame(width: 76, height: 20)
                 .background(Color.uclaBlue)
                 .cornerRadius(50)
             Text(dateStr)
                 .font(.system(size: 10))
                 .foregroundColor(.lightestBlue)
         }
         .padding(.top)
        
     }
}

#Preview {
    NavigationStack {
        ChatView(viewModel: .init(container: DIContainer(services: StubService()),
                                  chatRoomId: "chatRoom1_id",
                                  myUserId: "user1_id",
                                  otherUserId: "user2_id"))
    }
}
