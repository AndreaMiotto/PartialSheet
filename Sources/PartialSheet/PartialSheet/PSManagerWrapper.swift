//
//  PSManagerWrapper.swift
//
//  Created by Andrea Miotto on 15/09/21.
//  Copyright © 2021 Swift. All rights reserved.
//

import Foundation
import SwiftUI

/// A wrapper between the PartialSheetManager and the View
struct PSManagerWrapper<Parent: View, SheetContent: View>: View {
    @EnvironmentObject var partialSheetManager: PSManager
    
    @Binding var isPresented: Bool
    let type: PSType
    let iPhoneStyle: PSIphoneStyle
    let iPadMacStyle: PSIpadMacStyle
    let slideAnimation: PSSlideAnimation?
    let dissmissOnTap: Bool
    let content: () -> SheetContent
    let parent: Parent
    
    var body: some View {
        parent
            .onChange(of: isPresented, perform: {_ in updateContent() })
            .onDisappear {
                self.isPresented = false
            }
    }
    
    private func updateContent() {
        partialSheetManager.updatePartialSheet(
            isPresented: isPresented,
            type: type,
            iPhoneStyle: iPhoneStyle,
            iPadMacStyle: iPadMacStyle,
            slideAnimation: slideAnimation,
            content: content,
            dismissOnTap: dissmissOnTap,
            onDismiss: { self.isPresented = false}
        )
    }
    
}
