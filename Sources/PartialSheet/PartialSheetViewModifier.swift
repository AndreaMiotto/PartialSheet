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
@available(iOSApplicationExtension, unavailable)
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
    @State private var keyboardOffset: CGFloat = 0
    
    /// The offset for the drag gesture
    @State private var dragOffset: CGFloat = 0

    /// The point for the top anchor
    private var topAnchor: CGFloat {
        let topSafeArea = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
        let bottomSafeArea = (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
        
        let calculatedTop =
            presenterContentRect.height +
            topSafeArea +
            bottomSafeArea -
            sheetContentRect.height -
            handlerSectionHeight
          
        guard calculatedTop < style.minTopDistance else {
            return calculatedTop
        }
        
        return style.minTopDistance
    }
    
    /// The he point for the bottom anchor
    private var bottomAnchor: CGFloat {
        return UIScreen.main.bounds.height + 5
    }
    
    /// The height of the handler bar section
    private var handlerSectionHeight: CGFloat {
        switch style.handlerBarStyle {
            case .solid: return 30
            case .none: return 0
        }
    }
    
    /// Calculates the sheets y position
    private var sheetPosition: CGFloat {
        if self.manager.isPresented {
            // 20.0 = To make sure we dont go under statusbar on screens without safe area inset
            let topInset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20.0
            let position = self.topAnchor + self.dragOffset - self.keyboardOffset
            
            if position < topInset {
                return topInset
            }
            
            return position
        } else {
            return self.bottomAnchor - self.dragOffset
        }
    }

    /// Background of sheet
    private var background: AnyView {
        switch self.style.background {
        case .solid(let color):
            return AnyView(color)
        case .blur(let effect):
            return AnyView(BlurEffectView(style: effect).background(Color.clear))
        }
    }
    
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
                        DispatchQueue.main.async {
                            self.presenterContentRect = prefData.first?.bounds ?? .zero
                        }
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
@available(iOSApplicationExtension, unavailable)
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
                        .foregroundColor(style.iPadCloseButtonColor)
                        .padding(.horizontal)
                        .padding(.top)
                })
            }
            self.manager.content
            Spacer()
        }.background(self.background)
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
                    withAnimation(manager.defaultAnimation) {
                        self.manager.isPresented = false
                        self.dismissKeyboard()
                        self.manager.onDismiss?()
                    }
                }
            }
            // The SHEET VIEW
            Group {
                VStack(spacing: 0) {
                    switch style.handlerBarStyle {
                    case .solid(let handlerBarColor): // This is the little rounded bar (HANDLER) on top of the sheet
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                                .frame(width: 40, height: 5)
                                .foregroundColor(handlerBarColor)
                            Spacer()
                        }
                        .frame(height: handlerSectionHeight)
                    case .none: EmptyView()
                    }
                    
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
                    DispatchQueue.main.async {
                        withAnimation(manager.defaultAnimation) {
                            self.sheetContentRect = prefData.first?.bounds ?? .zero
                        }
                    }
                })
                .frame(width: UIScreen.main.bounds.width)
                .background(self.background)
                .cornerRadius(style.cornerRadius)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                .offset(y: self.sheetPosition)
                .gesture(drag)
            }
        }
    }
}

// MARK: - Drag Gesture & Handler
@available(iOSApplicationExtension, unavailable)
extension PartialSheet {

    /// Create a new **DragGesture** with *updating* and *onEndend* func
    private func dragGesture() -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
            .onChanged(onDragChanged)
            .onEnded(onDragEnded)
    }
    
    private func onDragChanged(drag: DragGesture.Value) {
        self.dismissKeyboard()
        let yOffset = drag.translation.height
        let threshold = CGFloat(-50)
        let stiffness = CGFloat(0.3)
        if yOffset > threshold {
            dragOffset = drag.translation.height
        } else if
            // if above threshold and belove ScreenHeight make it elastic
            -yOffset + self.sheetContentRect.height <
                UIScreen.main.bounds.height + self.handlerSectionHeight
        {
            let distance = yOffset - threshold
            let translationHeight = threshold + (distance * stiffness)
            dragOffset = translationHeight
        }
    }
    
    /// The method called when the drag ends. It moves the sheet in the correct position based on the last drag gesture
    private func onDragEnded(drag: DragGesture.Value) {
        /// The drag direction
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        
        // Set the correct anchor point based on the vertical direction of the drag
        if verticalDirection > 1 {
            DispatchQueue.main.async {
                withAnimation(manager.defaultAnimation) {
                    dragOffset = 0
                    self.manager.isPresented = false
                    self.manager.onDismiss?()
                }
            }
        } else if verticalDirection < 0 {
            withAnimation(manager.defaultAnimation) {
                dragOffset = 0
                self.manager.isPresented = true
            }
        } else {
            /// The current sheet position
            let cardTopEdgeLocation = topAnchor + drag.translation.height
            
            // Get the closest anchor point based on the current position of the sheet
            let closestPosition: CGFloat
            
            if (cardTopEdgeLocation - topAnchor) < (bottomAnchor - cardTopEdgeLocation) {
                closestPosition = topAnchor
            } else {
                closestPosition = bottomAnchor
            }
            
            withAnimation(manager.defaultAnimation) {
                dragOffset = 0
                self.manager.isPresented = (closestPosition == topAnchor)
                if !manager.isPresented {
                    manager.onDismiss?()
                }
            }
        }
    }
}

// MARK: - Keyboard Handlers Methods
@available(iOSApplicationExtension, unavailable)
extension PartialSheet {

    /// Add the keyboard offset
    private func keyboardShow(notification: Notification) {
        let endFrame = UIResponder.keyboardFrameEndUserInfoKey
        if let rect: CGRect = notification.userInfo![endFrame] as? CGRect {
            let height = rect.height
            let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom
            withAnimation(manager.defaultAnimation) {
                self.keyboardOffset = height - (bottomInset ?? 0)
            }
        }
    }

    /// Remove the keyboard offset
    private func keyboardHide(notification: Notification) {
        DispatchQueue.main.async {
            withAnimation(manager.defaultAnimation) {
                self.keyboardOffset = 0
            }
        }
    }
    
    /// Dismiss the keyboard
    private func dismissKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - PreferenceKeys Handlers
@available(iOSApplicationExtension, unavailable) 
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

struct PartialSheetAddView<Base: View, InnerContent: View>: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @Binding var isPresented: Bool
    let content: () -> InnerContent
    let base: Base
    
    @State var model = Model()

    var body: some View {
        if #available(iOS 14.0, *) {
            return AnyView(base
                .onChange(of: isPresented, perform: {_ in updateContent() }))
        } else {
            if model.update(value: isPresented) {
                DispatchQueue.main.async(execute: updateContent)
            }
            return AnyView(base)
        }
    }
    
    func updateContent() {
        partialSheetManager.updatePartialSheet(isPresented: isPresented, content: content, onDismiss: {
            self.isPresented = false
        })
    }
    
    // hack around .onChange not being available in iOS13
    class Model {
        private var savedValue: Bool?
        func update(value: Bool) -> Bool {
            guard value != savedValue else { return false }
            savedValue = value
            return true
        }
    }
}

public extension View {
    func partialSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        PartialSheetAddView(isPresented: isPresented, content: content, base: self)
    }
}
