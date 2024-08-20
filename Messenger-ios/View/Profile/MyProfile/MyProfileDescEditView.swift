//
//  MyProfileDescEditView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/18/24.
//

import SwiftUI

/**
 My profile description edit view
 */
struct MyProfileDescEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var description: String
    
    var onCompleted: (String) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter a status message", text: $description)
                    .multilineTextAlignment(.center)  // center align
            }
            .toolbar {
                // Complete button
                Button("Done") {
                    dismiss()
                    onCompleted(description)
                }
                // Disable the button if the description is empty
                .disabled(description.isEmpty)
            }
        }
    }
}

#Preview {
    MyProfileDescEditView(description: "") { _ in
        
    }
}
