//
//  SettingItem.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import Foundation

/**
 Task 6: User Interface Setting Item 
 */
protocol SettingItemable {
    var label: String { get }
}

struct SectionItem: Identifiable {
    let id = UUID()
    let label: String
    let settings: [SettingItem]
}

struct SettingItem: Identifiable {
    let id = UUID()
    let item: SettingItemable
}
