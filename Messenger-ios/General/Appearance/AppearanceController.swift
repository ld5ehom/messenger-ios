//
//  AppearanceController.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import Foundation
import Combine

/**
 Task 6: Setting View appearance setting controller
 */
protocol AppearanceControllerable {
    var appearance: AppearanceType { get set }
    
    func changeAppearance(_ willBeAppearance: AppearanceType?)
}

class AppearanceController: AppearanceControllerable, ObservableObject {
    
    @Published var appearance: AppearanceType
    
    init(_ appearanceValue: Int) {
        self.appearance = AppearanceType(rawValue: appearanceValue) ?? .automatic
    }
    
    func changeAppearance(_ willBeAppearance: AppearanceType?) {
        appearance = willBeAppearance ?? .automatic
    }
}
