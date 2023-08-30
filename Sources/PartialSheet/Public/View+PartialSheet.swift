//
//  View+PartialSheet.swift
//  PartialModal
//
//  Created by Miotto Andrea on 10/11/2019.
//  Copyright © 2019 Miotto Andrea. All rights reserved.
//

import SwiftUI

public extension View {
    /**
     Add a PartialSheet to the current view. You should attach it to your Root View.
     Then you can use the **func partialSheet** from any view in the hierarchy.

     ```
     let window = UIWindow(windowScene: windowScene)
     window.rootViewController = UIHostingController(
     rootView: contentView.attachPartialSheetToRoot()
     )
     ```
     Then in any view on the hierarchy you can use:
     ```
     view
     .partialSheet(isPresented: $isPresented) {
     Text("Content of the Sheet")
     }
     ```
     */
    func attachPartialSheetToRoot() -> some View {
        let sheetManager: PSManager = PSManager()
        return self
            .modifier(PartialSheet())
            .environmentObject(sheetManager)
    }

    /**
     Presents the **PartialSheet** attached to the root of the hierarchy.
     - parameter isPresented: Shows and hides the Partial Sheet.
     - parameter iPhoneStyle: The Partial Sheet's style for iPhone
     - parameter iPadMacStyle: The Partial Sheet's style for iPad and Mac
     - parameter slideAnimation: The custon animation for the slide in / out of the  Partial Sheet
     - parameter onDismiss: Allows presenter to call function when Partial Sheet is dismissed. Defaults to nil.
     - parameter content: The content of the Partial Sheet.
     */
    func partialSheet<Content: View>(isPresented: Binding<Bool>,
                                     type: PSType = PSType.dynamic,
                                     iPhoneStyle: PSIphoneStyle = .defaultStyle(),
                                     iPadMacStyle: PSIpadMacStyle = .defaultStyle(),
                                     slideAnimation: PSSlideAnimation? = nil,
                                     onDismiss: (() -> Void)? = nil,
                                     @ViewBuilder content: @escaping () -> Content) -> some View {
        PSManagerWrapper(
            isPresented: isPresented,
            type: type,
            iPhoneStyle: iPhoneStyle,
            iPadMacStyle: iPadMacStyle,
            slideAnimation: slideAnimation,
            content: content,
            parent: self,
            onDismiss: onDismiss
        )
    }
}
