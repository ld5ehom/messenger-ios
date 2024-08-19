//
//  MyProfileView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/17/24.
//

// Updates performed in Task 3 - Profile View
import SwiftUI
import PhotosUI

struct MyProfileView: View {

    @Environment(\.dismiss) var dismiss   // X Close Button
    @StateObject var viewModel: MyProfileViewModel
    
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
                    
                    profileView
                        .padding(.bottom, 16)
                    
                    nameView
                        .padding(.bottom, 26)
                    
                    descriptionView
                    
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
    
    var profileView: some View {
        // Added Photos Picker functionality for profile image (task 3)
        PhotosPicker(selection: $viewModel.imageSelection,
                     matching: .images) {
            Image("taewook")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
        }
    }
    
    var nameView: some View {
        Text(viewModel.userInfo?.name ?? "Name")
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.darkestBlue)
    }
    
    var descriptionView: some View {
        Button {
            viewModel.isPresentedDescEditView.toggle()
        } label: {
            Text(viewModel.userInfo?.description ?? "Please enter a status message." )
                .font(.system(size: 14))
                .foregroundColor(.uclaBlue)
        }
        .sheet(isPresented: $viewModel.isPresentedDescEditView) {
            MyProfileDescEditView(description: viewModel.userInfo?.description ?? "") { willBeDesc in
                // TODO: firebase DB update
                Task {
                    await viewModel.updateDescription(willBeDesc)
                }
            }
        }
    }
    
    var menuView: some View {
       HStack(alignment: .top, spacing: 27) {
           ForEach(MyProfileMenuType.allCases, id: \.self) { menu in
               Button {
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
    MyProfileView(viewModel: .init(container: DIContainer(services: StubService()), userId: "user1_id"))
}
