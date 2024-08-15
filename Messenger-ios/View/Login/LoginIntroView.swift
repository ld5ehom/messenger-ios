//
//  LoginIntroView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import SwiftUI

struct LoginIntroView: View {
    
    // Declare a state variable to bind with Presented
    @State private var isPresentedLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Text("Welcome!")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(Color("UCLA Blue"))
                
                Spacer()
                
                Button(action: {
                    isPresentedLoginView.toggle()
                }) {
                    Text("Sign In")
                }
                .buttonStyle(LoginButtonStyle(textColor: Color("UCLA Blue")))

            }
            .navigationDestination(isPresented: $isPresentedLoginView) {
                LoginView()
            }
        }
    }
}

#Preview {
    LoginIntroView()
}
