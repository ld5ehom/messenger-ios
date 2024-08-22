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
 */

class SearchDataController: ObservableObject {
    
    let persistantContainer = NSPersistentContainer(name: "Search")
    
    init() {
        persistantContainer.loadPersistentStores { description, error in
            if let error {
                print("Core data failed: ", error.localizedDescription)
            }
        }
    }
}
