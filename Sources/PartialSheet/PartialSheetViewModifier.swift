//
//  PartialSheetViewModifier.swift
//  PartialModal
//
//  Created by Miotto Andrea on 09/11/2019.
//  Copyright © 2019 Miotto Andrea. All rights reserved.
//

import SwiftUI
import Combine

/// This is the modifier for the Partial Sheet
struct PartialSheet<SheetContent>: ViewModifier where SheetContent: View {
    
    // MARK: - Public Properties
    
    /// Tells if the sheet should be presented or not
    @Binding var presented: Bool

    /// The Partial Sheet Style configuration
    var style: PartialSheetStyle

    /// The content of the sheet
    var sheetContent: () -> SheetContent

    /// Void func that will be called on dismiss
    var onDismiss: (() -> Void)?
    
    // MARK: - Private Properties
    
    /// The rect containing the content
    @State private var presenterContentRect: CGRect = .zero
    
    /// The rect containing the content
    @State private var sheetContentRect: CGRect = .zero
    
    /// The offset for keyboard height
    @State private var offset: CGFloat = 0
    
    /// The point for the top anchor
    private var topAnchor: CGFloat {
        return max(presenterContentRect.height - sheetContentRect.height - handlerSectionHeight, 110)
    }
    
    /// The he point for the bottom anchor
    private var bottomAnchor: CGFloat {
        return UIScreen.main.bounds.height + 5
    }
    
    /// The current anchor point, based if the **presented** property is true or false
    private var currentAnchorPoint: CGFloat {
        return presented ?
            topAnchor :
        bottomAnchor
    }
    
    /// The height of the handler bar section
    private var handlerSectionHeight: CGFloat {
        return 30
    }
    
    /// The Gesture State for the drag gesture
    @GestureState private var dragState = DragState.inactive
    
    // MARK: - Content Builders
    
    func body(content: Content) -> some View {
        ZStack {
            content
                // if the device type is an iPhone
                .iPhone {
                    $0
                        .background(
                            GeometryReader { proxy -> AnyView in
                                let rect = proxy.frame(in: .global)
                                // This avoids an infinite layout loop
                                if rect.integral != self.presenterContentRect.integral {
                                    DispatchQueue.main.async {
                                        self.presenterContentRect = rect
                                    }
                                }
                                return AnyView(EmptyView())
                            }
                    )
                        .padding(.bottom, self.offset)
                        .onAppear{
                            let notifier = NotificationCenter.default
                            let willShow = UIResponder.keyboardWillShowNotification
                            let willHide = UIResponder.keyboardWillHideNotification
                            notifier.addObserver(forName: willShow,
                                                 object: nil,
                                                 queue: .main,
                                                 using: self.keyboardShow)
                            notifier.addObserver(forName: willHide,
                                                 object: nil,
                                                 queue: .main,
                                                 using: self.keyboardHide)
                    }
                    .onDisappear {
                        let notifier = NotificationCenter.default
                        notifier.removeObserver(self)
                    }
            }
                // if the device type is not an iPhone,
                // display the sheet content as a normal sheet
                .iPadAndMac {
                        $0
                            .sheet(isPresented: $presented, onDismiss: {
                                self.onDismiss?()
                            }, content: {
                                self.iPandAndMacSheet()
                            })
            }
            // if the device type is an iPhone,
            // display the sheet content as a draggableSheet
            if deviceType == .iphone {
                iPhoneSheet()
                    .edgesIgnoringSafeArea(.vertical)
            }
        }
    }

     /// This is the builder for the sheet content for iPad and Mac devices only
    private func iPandAndMacSheet() -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presented = false
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(style.handlerBarColor)
                        .padding(.horizontal)
                        .padding(.top)
                })
            }
            self.sheetContent()
            Spacer()
        }
    }

    /// This is the builder for the sheet content for iPhone devices only
    private func iPhoneSheet()-> some View {
        // Build the drag gesture
        let drag = dragGesture()
        
        return ZStack {

            // Attach the COVER VIEW
            if presented && style.enableCover {
                Rectangle()
                    .foregroundColor(style.coverColor)
                    .edgesIgnoringSafeArea(.vertical)
                    .onTapGesture {
                        withAnimation {
                            self.presented = false
                            self.dismissKeyboard()
                            self.onDismiss?()
                        }
                }
            }
            // The SHEET VIEW
            Group {
                VStack(spacing: 0) {
                    // This is the little rounded bar (HANDLER) on top of the sheet
                    VStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                            .frame(width: 40, height: 5)
                            .foregroundColor(self.style.handlerBarColor)
                        Spacer()
                    }
                    .frame(height: handlerSectionHeight)
                    VStack {
                        // Attach the SHEET CONTENT
                        self.sheetContent()
                            .background(
                                GeometryReader { proxy -> AnyView in
                                    let rect = proxy.frame(in: .global)
                                    // This avoids an infinite layout loop
                                    if rect.integral != self.sheetContentRect.integral {
                                        DispatchQueue.main.async {
                                            self.sheetContentRect = rect
                                        }
                                    }
                                    return AnyView(EmptyView())
                                }
                        )
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(style.backgroundColor)
                .cornerRadius(10.0)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                .offset(y: self.presented ?
                    self.topAnchor + self.dragState.translation.height : self.bottomAnchor - self.dragState.translation.height
                )
                    .animation(self.dragState.isDragging ?
                        nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(drag)
            }
        }
    }

    // MARK: - Drag Gesture & Handler

    /// Create a new **DragGesture** with *updating* and *onEndend* func
    private func dragGesture() -> _EndedGesture<GestureStateGesture<DragGesture, DragState>> {
        DragGesture()
            .updating($dragState) { drag, state, _ in
                self.dismissKeyboard()
                let yOffset = drag.translation.height
                let threshold = CGFloat(-50)
                let stiffness = CGFloat(0.3)
                if yOffset > threshold {
                    state = .dragging(translation: drag.translation)
                } else if
                    // if above threshold and belove ScreenHeight make it elastic
                    -yOffset + self.sheetContentRect.height <
                        UIScreen.main.bounds.height + self.handlerSectionHeight
                {
                    let distance = yOffset - threshold
                    let translationHeight = threshold + (distance * stiffness)
                    state = .dragging(translation: CGSize(width: drag.translation.width, height: translationHeight))
                }
        }
        .onEnded(onDragEnded)
    }
    
    /// The method called when the drag ends. It moves the sheet in the correct position based on the last drag gesture
    private func onDragEnded(drag: DragGesture.Value) {
        /// The drag direction
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        /// The current sheet position
        let cardTopEdgeLocation = topAnchor + drag.translation.height
        
        // Get the closest anchor point based on the current position of the sheet
        let closestPosition: CGFloat
        
        if (cardTopEdgeLocation - topAnchor) < (bottomAnchor - cardTopEdgeLocation) {
            closestPosition = topAnchor
        } else {
            closestPosition = bottomAnchor
        }
        
        // Set the correct anchor point based on the vertical direction of the drag
        if verticalDirection > 1 {
            DispatchQueue.main.async {
                self.presented = false
                self.onDismiss?()
            }
        } else if verticalDirection < 0 {
            self.presented = true
        } else {
            self.presented = (closestPosition == topAnchor)
            if !presented {
                onDismiss?()
            }
        }
    }
    
    
    // MARK: - Keyboard Handlers Methods
    
    /// Add the keyboard offset
    private func keyboardShow(notification: Notification) {
        let endFrame = UIResponder.keyboardFrameEndUserInfoKey
        if let rect: CGRect = notification.userInfo![endFrame] as? CGRect {
            let height = rect.height
            let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
            self.offset = height - (bottomInset ?? 0)
        }
    }
    
    /// Remove the keyboard offset
    private func keyboardHide(notification: Notification) {
        DispatchQueue.main.async {
            self.offset = 0
        }
    }
    
    /// Dismiss the keyboard
    private func dismissKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
