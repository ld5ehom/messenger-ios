//
//  OtherProfileView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/17/24.
//

import SwiftUI

/**
  Task 3: Other(Friend) profile view UI
 */
struct OtherProfileView: View {
    @Environment(\.dismiss) var dismiss   // X Close Button
    @StateObject var viewModel: OtherProfileViewModel
    
    // Starts a chat with another user
    var goToChat: (User) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                // background image
                Image("RoyceHall")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(edges: .vertical)
                
                // Bottom Menu
                VStack(spacing: 0) {
                    Spacer()

                    URLImageView(urlString: viewModel.userInfo?.profileURL)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                    
                    Text(viewModel.userInfo?.name ?? "Name")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.uclaBlue)
                    
                    Spacer()
                    
                    menuView
                        .padding(.bottom, 20)
                }
            }
            
            // X Close Button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 25))
                            .foregroundColor(.darkestBlue)
                    }
                }
            }
            .task {
               await viewModel.getUser()
           }
        }
    }
    
    var menuView: some View {
       HStack(alignment: .top, spacing: 50) {
           ForEach(OtherProfileMenuType.allCases, id: \.self) { menu in
               Button {
                   if menu == .chat, let userInfo = viewModel.userInfo {
                       dismiss()
                       goToChat(userInfo)
                   }
               } label: {
                   VStack(alignment: .center) {
                       // MyProfileMenuType.Assets Image File
//                       Image(menu.imageName)
//                           .resizable()
//                           .frame(width: 50, height: 50)
                       
                       // Xcode System Image
                       Image(systemName: menu.imageName)
                           .resizable()
                           .frame(width: 30, height: 30)
                           .foregroundColor(.uclaBlue)
                       
                       Text(menu.description)
                           .font(.system(size: 15))
                           .foregroundColor(.darkestBlue)
                   }
               }
           }
       }
   }
}

#Preview {
    OtherProfileView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user2_id")) { _ in
        
    }
}
