//
//  LoginView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/14/24.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    // Back button Environment
    @Environment(\.dismiss) var dismiss
    
    /*
     * Retrieves the authentication view model from the environment
     */
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Sign In")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.uclaBlue)
                    .padding(.top, 80)
            }
            .padding(.horizontal, 50)
            
            Spacer()
            
            // Google Login Button
            Button(action: {
                authViewModel.send(action: .googleLogin)
            }) {
                Text("Sign in with Google")
            }
            .buttonStyle(LoginButtonStyle(textColor: Color("UCLA Blue")))
            
            // Apple Login Button
            SignInWithAppleButton { request in
                authViewModel.send(action: .appleLogin(request))
            } onCompletion: { result in
                authViewModel.send(action: .appleLoginCompletion(result))
            }
            .frame(height: 40)
            .padding(.horizontal, 15)
            .cornerRadius(5)

            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Back")
                })
            }
        }
        .overlay {
            if authViewModel.isLoading {
                ProgressView()
            }
        }
    }
}


#Preview {
    LoginView()
}
