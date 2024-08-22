//
//  NavigationRouter.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/19/24.
//

import Foundation
import Combine

/**
  Task 3: Other(Friend) view navigation
 */
protocol NavigationRoutable {
    var destinations: [NavigationDestination] { get set }
    
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
}

class NavigationRouter: ObservableObject {
    
    var objectWillChange: ObservableObjectPublisher?
    
    // Published property to manage the navigation stack for the HomeView
    @Published var destinations: [NavigationDestination] = []
    
    // Adds a new view to the navigation stack
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    // Removes the last view from the navigation stack
    func pop() {
        _ = destinations.popLast()
    }
    
    // Clears the navigation stack to return to the root view
    func popToRootView() {
        destinations = []
    }
}
