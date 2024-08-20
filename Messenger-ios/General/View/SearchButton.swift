//
//  SearchButton.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import SwiftUI

/**
 Task 3: OtherProfileView
 Navigates to the Search view when the search button is tapped in OtherProfileView
 
 Search Button UI 
 */
struct SearchButton: View {
    var body: some View {
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
