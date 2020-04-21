//
//  View+PartialSheetModifier.swift
//  PartialModal
//
//  Created by Miotto Andrea on 10/11/2019.
//  Copyright © 2019 Miotto Andrea. All rights reserved.
//

import SwiftUI

extension View {

    /**
     Presents a **Partial Sheet**  with a dynamic height based on his content.
     - parameter presented: This should be set to true when the Partial Sheet has to be displayed.
     - parameter style: The stayle configuration for the Partial Sheet.
     - parameter onDismiss: This code will be runned when the sheet in dismissed.
     - parameter view: The content to place inside of the Partial Sheet.
     */
    public func partialSheet<SheetContent: View>(
        presented: Binding<Bool>,
        style: PartialSheetStyle = PartialSheetStyle.defaultStyle(),
        onDismiss: (() -> Void)? = nil,
        view: @escaping () -> SheetContent ) -> some View {
        self.modifier(
            PartialSheet(
                presented: presented,
                style: style,
                sheetContent: view,
                onDismiss: onDismiss
            )
        )
    }
}
