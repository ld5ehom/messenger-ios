//
//  KeyboardToolbar.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import SwiftUI

/**
 Task 4: Chat view 
 A view modifier that adds a toolbar at the bottom of the view, positioned above the keyboard.

 - Parameters:
    - height: The height of the toolbar.
    - toolbarView: A closure that provides the content of the toolbar.

 This modifier adjusts the content view's height to ensure the toolbar is visible above the keyboard.
 */
struct KeyboardToolbar<ToolbarView: View>: ViewModifier {
    private let height: CGFloat
    private let toolbarView: ToolbarView
    
    init(height: CGFloat, @ViewBuilder toolbarView: () -> ToolbarView) {
        self.height = height
        self.toolbarView = toolbarView()
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                content
                    .frame(width: proxy.size.width, height: proxy.size.height - height)
            }
            toolbarView
                .frame(height: height)
        }
    }
}

extension View {
    /**
     Adds a toolbar above the keyboard to the view.

     - Parameters:
        - height: The height of the toolbar.
        - view: A closure that provides the content of the toolbar.

     - Returns: A view with the toolbar modifier applied.
     */
    func keyboardToolbar<ToolbarView>(height: CGFloat, view: @escaping () -> ToolbarView) -> some View where ToolbarView: View {
        modifier(KeyboardToolbar(height: height, toolbarView: view))
    }
}
