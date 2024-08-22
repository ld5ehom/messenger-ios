//
//  SettingView.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/22/24.
//

import SwiftUI

/**
 Task 6: User Interface Setting View Model
 */
struct SettingView: View {
    // AppStorage property wrapper for storing and retrieving the appearance setting.
    @AppStorage(AppStorageType.Appearance) var appearance: Int = UserDefaults.standard.integer(forKey: AppStorageType.Appearance)
    
    // Environment property wrapper to dismiss the current view.
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appearanceController: AppearanceController
    @StateObject var viewModel: SettingViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sectionItems) { section in
                    Section {
                        ForEach(section.settings) { setting in
                            Button {
                                if let a = setting.item as? AppearanceType {
                                    // Test Setting View appearance
//                                    viewModel.send(action: .changeAppearance(a))
//                                    appearance = a.rawValue
                                    appearanceController.changeAppearance(a)
                                    appearance = a.rawValue
                                }
                            } label: {
                                Text(setting.item.label)
                                    .foregroundColor(.uclaBlue)
                            }
                        }
                    } header: {
                        Text(section.label)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        // Test Setting View appearance
//        .preferredColorScheme(viewModel.appearance.colorScheme)
        .preferredColorScheme(appearanceController.appearance.colorScheme)
    }
}


#Preview {
    SettingView(viewModel: .init())
}

