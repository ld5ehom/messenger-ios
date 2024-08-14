//
//  DIContainer.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

class DIContainer: ObservableObject {
    
    // service property 
    var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
