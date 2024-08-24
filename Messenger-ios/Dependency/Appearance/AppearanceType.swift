//
//  AppearanceType.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import SwiftUI
/**
 Task 6: Setting View
 */

enum AppearanceType: Int, CaseIterable, SettingItemable {
    case automatic
    case light
    case dark
    
    // Provides the display label for each appearance mode.
    var label: String {
        switch self {
        case .automatic:
            return "System Mode"
        case .light:
            return "Light Mode"
        case .dark:
            return "Dark Mode"
        }
    }
    
    // Provides the corresponding ColorScheme for each appearance mode.
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic:
            return nil // default.
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

