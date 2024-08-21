//
//  ChatItemView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import SwiftUI

/**
 Task 4: Separates my messages and friend's messages into left and right sides in the Chat View.
 */
struct ChatItemView: View {
    let message: String
    let direcion: ChatItemDirection
    let date: Date
    
    var body: some View {
        HStack(alignment: .bottom) {
            // My message
            if direcion == .right {
                Spacer()
                dateView
            }
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(direcion.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 50))
            
                // overlay message image
                .overlay(alignment: direcion.overlayAlignment) {
                    direcion.overlayImage
                }
            
            // other message
            if direcion == .left {
                dateView
                Spacer()
            }
        }
        .padding(.horizontal, 35)
        .padding(.bottom)
    }
    
    // message date and time
    var dateView: some View {
        Text(date.toChatTime)
            .font(.system(size: 10))
            .foregroundColor(.darkerBlue)
            .accessibilityLabel(Text(date.toChatTimeAccessibility))
    }
}

#Preview {
    ChatItemView(message: "Hi,I'm Taewook", direcion: .right, date: Date())
}
