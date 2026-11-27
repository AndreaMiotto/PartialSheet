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
    
    @State private var owner = UUID()
    @Binding var isPresented: Bool
    let type: PSType
    let iPhoneStyle: PSIphoneStyle
    let iPadMacStyle: PSIpadMacStyle
    let slideAnimation: PSSlideAnimation?
    let content: () -> SheetContent
    let parent: Parent
    var onDismiss: (() -> Void)?
    
    var body: some View {
        parent
            .onAppear { if isPresented { updateContent() } }
            .onDisappear {
                if partialSheetManager.owner == owner { partialSheetManager.dismiss() }
            }
            .onChange(of: isPresented, perform: {_ in updateContent() })
    }
    
    private func updateContent() {
        partialSheetManager.updatePartialSheet(
            owner: owner,
            isPresented: isPresented,
            type: type,
            iPhoneStyle: iPhoneStyle,
            iPadMacStyle: iPadMacStyle,
            slideAnimation: slideAnimation,
            content: content,
            onDismiss: {
                self.isPresented = false
                onDismiss?()
            }
        )
    }
    
}
