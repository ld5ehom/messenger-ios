//
//  URLImageView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import SwiftUI

/**
 Task 3: Creates a view that replaces async image loading using an image cache.
 */
struct URLImageView: View {
    @EnvironmentObject var container: DIContainer
    
    let urlString: String?
    let placeholderName: String
    
    // Initializes with an optional URL string and a placeholder image name.
    init(urlString: String?, placeholderName: String? = "placeholdertext.fill") {
        self.urlString = urlString
        self.placeholderName = placeholderName ?? "placeholdertext.fill"
    }
    
    var body: some View {
        if let urlString, !urlString.isEmpty {
            URLInnerImageView(viewModel: .init(container: container, urlString: urlString), placeholderName: placeholderName)
                .id(urlString)
        } else {
            Image(placeholderName)
                .resizable()
        }
    }
}


// Wraps the image view in a container view
fileprivate struct URLInnerImageView: View {
    @StateObject var viewModel: URLImageViewModel
    
    let placeholderName: String
    
    var placeholderImage: UIImage {
        UIImage(named: placeholderName) ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: viewModel.loadedImage ?? placeholderImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onAppear {
                if !viewModel.loadingOrSuccess {
                    viewModel.start()
                }
            }
    }
}

#Preview {
    URLImageView(urlString: nil)
}
