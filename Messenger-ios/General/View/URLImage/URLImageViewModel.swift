//
//  URLImageViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import UIKit
import Combine

/**
 Task 3: Creates a view that replaces async image loading using an image cache.
 */
class URLImageViewModel: ObservableObject {
    
    // Checks if loading is in progress or if the image has already been loaded successfully.
    var loadingOrSuccess: Bool {
        return loading || loadedImage != nil
    }
    
    @Published var loadedImage: UIImage?
    
    private var loading: Bool = false
    private var urlString: String
    private var container: DIContainer
    private var subscriptions = Set<AnyCancellable>()

    init(container: DIContainer, urlString: String) {
        self.container = container
        self.urlString = urlString
    }
    
    // Retrieves an image from the cache and updates loading and image properties.
    func start() {
        // Checks if the URL string is empty
        guard !urlString.isEmpty else {
            return
        }
        
        // Sets loading flag to true
        loading = true
        
        container.services.imageCacheService.image(for: urlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.loading = false
                self?.loadedImage = image
            }.store(in: &subscriptions)
    }
}
