//
//  PSManager.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import Combine
import SwiftUI
/**
 The Partial Sheet Manager helps to handle the Partial Sheet when there are many view layers.
 Make sure to pass an instance of this manager as an **environmentObject** to your root view:
 ```
 let sheetManager: PSManager = PSManager()
 contentView.environmentObject(sheetManager)
 ```
 */
class PSManager: ObservableObject {
    
    /// Published var to present or hide the partial sheet
    @Published var isPresented: Bool = false {
        didSet {
            if !isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    self?.content = EmptyView().eraseToAnyView()
                    self?.onDismiss = nil
                }
            }
        }
    }
    /// The content of the sheet
    @Published private(set) var content: AnyView

    /// The Partial Sheet Type
    var type: PSType = .dynamic
    

    /// The Partial Sheet Style configuration
    var iPhoneStyle: PSIphoneStyle = .defaultStyle()
    var iPadMacStyle : PSIpadMacStyle = .defaultStyle()

    /// the onDismiss code runned when the partial sheet is closed
    private(set) var onDismiss: (() -> Void)?
    
    /**
     Modify this property to change the slide in/out animation.
     You can restore the default one calling **restoreDefaultSlideAnimation**
     **/
    var slideAnimation: PSSlideAnimation
    
    /**
     You only need to set false when you  DatePicker with .datePickerStyle(.graphical)
     */
    var dragGestureSupported: Bool = true

    
    init() {
        content = EmptyView().eraseToAnyView()
        slideAnimation = PSSlideAnimation()
    }
    
    /**
     Updates the properties of the **Partial Sheet**
     */
    func updatePartialSheet<T>(isPresented: Bool,
                               type: PSType,
                               iPhoneStyle: PSIphoneStyle,
                               iPadMacStyle: PSIpadMacStyle,
                               slideAnimation: PSSlideAnimation?,
                               dragGestureSupported: Bool,
                               content: (() -> T),
                               onDismiss: @escaping (() -> Void)) where T: View {
        self.content = AnyView(content())
        self.dragGestureSupported = dragGestureSupported
        self.type = type
        self.iPhoneStyle = iPhoneStyle
        self.iPadMacStyle = iPadMacStyle
        self.onDismiss = onDismiss
        self.slideAnimation = slideAnimation ?? PSSlideAnimation()
        withAnimation(isPresented ? self.slideAnimation.slideIn : self.slideAnimation.slideOut) {
            self.isPresented = isPresented
        }
    }
}
