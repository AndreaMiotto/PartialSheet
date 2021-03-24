//
//  PartialSheetManager.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 29/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import Combine
import SwiftUI

/**
 The Partial Sheet Manager helps to handle the Partial Sheet when you have many view layers.

 Make sure to pass an instance of this manager as an **environmentObject** to your root view in your Scene Delegate:
 ```
 let sheetManager: PartialSheetManager = PartialSheetManager()
 let window = UIWindow(windowScene: windowScene)
 window.rootViewController = UIHostingController(
 rootView: contentView.environmentObject(sheetManager)
 )
 ```
 */
public class PartialSheetManager: ObservableObject {

    /// Published var to present or hide the partial sheet
    @Published var isPresented: Bool = false {
        didSet {
            if !isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                    self?.content = AnyView(EmptyView())
                    self?.onDismiss = nil
                }
            }
        }
    }
    /// The content of the sheet
    @Published private(set) var content: AnyView
    /// the onDismiss code runned when the partial sheet is closed
    private(set) var onDismiss: (() -> Void)?

    /// Possibility to customize the slide in/out animation of the partial sheet
    public var defaultAnimation: Animation = .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0)

    public init() {
        self.content = AnyView(EmptyView())
    }

    /**
      Presents a **Partial Sheet**  with a dynamic height based on his content.
     - parameter content: The content to place inside of the Partial Sheet.
     - parameter onDismiss: This code will be runned when the sheet is dismissed.
     */
    public func showPartialSheet<T>(_ onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> T) where T: View {
        guard !isPresented else {
            withAnimation(defaultAnimation) {
                updatePartialSheet(
                    content: {
                        // do not animate the content, just the partial sheet
                        withAnimation(nil) {
                            content()
                        }
                    },
                    onDismiss: onDismiss)
            }
            return
        }

        self.content = AnyView(content())
        self.onDismiss = onDismiss
        DispatchQueue.main.async {
            withAnimation(self.defaultAnimation) {
                self.isPresented = true
            }
        }
    }

    /**
     Updates some properties of the **Partial Sheet**
    - parameter isPresented: If the partial sheet is presented
    - parameter content: The content to place inside of the Partial Sheet.
    - parameter onDismiss: This code will be runned when the sheet is dismissed.
    */
    public func updatePartialSheet<T>(isPresented: Bool? = nil, content: (() -> T)? = nil, onDismiss: (() -> Void)? = nil) where T: View {
        if let content = content {
            self.content = AnyView(content())
        }
        if let onDismiss = onDismiss {
            self.onDismiss = onDismiss
        }
        if let isPresented = isPresented {
            withAnimation(defaultAnimation) {
                self.isPresented = isPresented
            }
        }
    }

    /// Close the Partial Sheet and run the onDismiss function if it has been previously specified
    public func closePartialSheet() {
        withAnimation(defaultAnimation) {
            self.isPresented = false
        }
        self.onDismiss?()
    }
}
