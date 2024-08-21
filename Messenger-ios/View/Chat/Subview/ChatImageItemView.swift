//
//  ChatImageItemView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/21/24.
//

import SwiftUI

/**
 Task 4: chat view
 */
struct ChatImageItemView: View {
    let urlString: String
    let direction: ChatItemDirection
    let date: Date
    
    var body: some View {
        HStack(alignment: .bottom) {
            if direction == .right {
                Spacer()
                dateView
            }
            
            URLImageView(urlString: urlString)
                .frame(width: 146, height: 146)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if direction == .left {
                dateView
                Spacer()
            }
        }
        .padding(.horizontal, 35)
        .padding(.bottom)
    }
    
    var dateView: some View {
        Text(date.toChatTime)
            .font(.system(size: 10))
            .foregroundColor(.lightestBlue)
            .accessibilityLabel(Text(date.toChatTimeAccessibility))
    }
}

#Preview {
    ChatImageItemView(urlString: "", direction: .right, date: Date())
}
