//
//  SearchDataController.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import Foundation
import CoreData

/**
 Task 5: Search Core Data controller
 Task 7: DIContainer protocol
 */

// protocol for test
protocol DataControllable {
    var persistantContainer: NSPersistentContainer { get set }
}

class SearchDataController: DataControllable {
    
    var persistantContainer = NSPersistentContainer(name: "Search")
    
    init() {
        persistantContainer.loadPersistentStores { description, error in
            if let error {
                print("Core data failed: ", error.localizedDescription)
            }
        }
    }
}
