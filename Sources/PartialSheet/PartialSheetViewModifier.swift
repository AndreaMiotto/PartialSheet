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
struct PartialSheet: ViewModifier {
    
    // MARK: - Public Properties

    /// The Partial Sheet Style configuration
    var style: PartialSheetStyle
    
    // MARK: - Private Properties

    @EnvironmentObject private var manager: PartialSheetManager

    /// The rect containing the presenter
    @State private var presenterContentRect: CGRect = .zero
    
    /// The rect containing the sheet content
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
        return manager.isPresented ?
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
                            GeometryReader { proxy in
                                // Add a tracking on the presenter frame
                                Color.clear.preference(
                                    key: PresenterPreferenceKey.self,
                                    value: [PreferenceData(bounds: proxy.frame(in: .global))]
                                )
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
                    .onPreferenceChange(PresenterPreferenceKey.self, perform: { (prefData) in
                        self.presenterContentRect = prefData.first?.bounds ?? .zero
                    })
            }
                // if the device type is not an iPhone,
                // display the sheet content as a normal sheet
                .iPadOrMac {
                        $0
                            .sheet(isPresented: $manager.isPresented, onDismiss: {
                                self.manager.onDismiss?()
                            }, content: {
                                self.iPadAndMacSheet()
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
}

//MARK: - Platfomr Specific Sheet Builders
extension PartialSheet {

    //MARK: - Mac and iPad Sheet Builder

     /// This is the builder for the sheet content for iPad and Mac devices only
    private func iPadAndMacSheet() -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.manager.isPresented = false
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(style.handlerBarColor)
                        .padding(.horizontal)
                        .padding(.top)
                })
            }
            self.manager.content
            Spacer()
        }
    }

    //MARK: - iPhone Sheet Builder

    /// This is the builder for the sheet content for iPhone devices only
    private func iPhoneSheet()-> some View {
        // Build the drag gesture
        let drag = dragGesture()
        
        return ZStack {

            //MARK: - iPhone Cover View

            if manager.isPresented {
                Group {
                    if style.enableCover {
                        Rectangle()
                        .foregroundColor(style.coverColor)
                    }
                    if style.blurEffectStyle != nil {
                        BlurEffectView(style: style.blurEffectStyle ?? UIBlurEffect.Style.systemChromeMaterial)
                    }
                }
                    .edgesIgnoringSafeArea(.vertical)
                    .onTapGesture {
                        withAnimation {
                            self.manager.isPresented = false
                            self.dismissKeyboard()
                            self.manager.onDismiss?()
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
                        self.manager.content
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.preference(key: SheetPreferenceKey.self, value: [PreferenceData(bounds: proxy.frame(in: .global))])
                                }
                        )
                    }
                    Spacer()
                }
                .onPreferenceChange(SheetPreferenceKey.self, perform: { (prefData) in
                    self.sheetContentRect = prefData.first?.bounds ?? .zero
                })
                .frame(width: UIScreen.main.bounds.width)
                .background(style.backgroundColor)
                .cornerRadius(10.0)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                .offset(y: self.manager.isPresented ?
                    self.topAnchor + self.dragState.translation.height : self.bottomAnchor - self.dragState.translation.height
                )
                    .animation(self.dragState.isDragging ?
                        nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                    .gesture(drag)
            }
        }
    }
}

// MARK: - Drag Gesture & Handler
extension PartialSheet {

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
                self.manager.isPresented = false
                self.manager.onDismiss?()
            }
        } else if verticalDirection < 0 {
            self.manager.isPresented = true
        } else {
            self.manager.isPresented = (closestPosition == topAnchor)
            if !manager.isPresented {
                manager.onDismiss?()
            }
        }
    }
}

// MARK: - Keyboard Handlers Methods
extension PartialSheet {

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

// MARK: - PreferenceKeys Handlers
extension PartialSheet {

    /// Preference Key for the Sheet Presener
    struct PresenterPreferenceKey: PreferenceKey {
        static func reduce(value: inout [PartialSheet.PreferenceData], nextValue: () -> [PartialSheet.PreferenceData]) {
            value.append(contentsOf: nextValue())
        }
        static var defaultValue: [PreferenceData] = []
    }

    /// Preference Key for the Sheet Content
    struct SheetPreferenceKey: PreferenceKey {
        static func reduce(value: inout [PartialSheet.PreferenceData], nextValue: () -> [PartialSheet.PreferenceData]) {
            value.append(contentsOf: nextValue())
        }
        static var defaultValue: [PreferenceData] = []
    }

    /// Data Stored in the Preferences
    struct PreferenceData: Equatable {
        let bounds: CGRect
    }

}
