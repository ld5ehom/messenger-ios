//
//  DIContainer.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/13/24.
//

import Foundation

/**
 Task 7: Created a DIContainer class to manage dependencies and inject various services and controllers, including default implementations for testing purposes.
 */
class DIContainer: ObservableObject {
    var services: ServiceType
    var searchDataController: DataControllable
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    var appearanceController: AppearanceControllerable & ObservableObjectSettable
    
    init(services: ServiceType,
         searchDataController: DataControllable = SearchDataController(),
         navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter(),
         appearanceController: AppearanceControllerable & ObservableObjectSettable = AppearanceController()) {
        self.services = services
        self.searchDataController = searchDataController
        self.navigationRouter = navigationRouter
        self.appearanceController = appearanceController
        
        self.navigationRouter.setObjectWillChange(objectWillChange)
        self.appearanceController.setObjectWillChange(objectWillChange)
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubServices())
    }
}
