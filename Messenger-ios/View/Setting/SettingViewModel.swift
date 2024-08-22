//
//  SettingViewModel.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import Foundation

/**
 Task 6: User Interface Setting View Model
 */
class SettingViewModel: ObservableObject {
    
    // Test
//    enum Action {
//        case changeAppearance(AppearanceType)
//    }
    
    // Published property that triggers view updates when sectionItems changes.
    @Published var sectionItems: [SectionItem] = []
    
    // Test
//    @Published var appearance: AppearanceType = .automatic


    init() {
        self.sectionItems = [
            // Create a SectionItem with a label and settings based on AppearanceType.
            .init(label: "Appearance Settings", settings: AppearanceType.allCases.map { .init(item: $0) })
        ]
    }
    
    // Test
//    func send(action: Action) {
//        switch action {
//        case let .changeAppearance(willBeAppearance):
//            appearance = willBeAppearance
//        }
//    }
}
