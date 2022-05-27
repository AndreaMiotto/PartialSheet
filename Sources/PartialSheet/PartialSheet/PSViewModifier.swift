//
//  PSViewModifier.swift
//  PartialModal
//
//  Created by Miotto Andrea on 09/11/2019.
//  Copyright © 2019 Miotto Andrea. All rights reserved.
//

import SwiftUI
import Combine

/// This is the modifier for the Partial Sheet
struct PartialSheet: ViewModifier {
    
    // MARK: - Private Properties
    
    @EnvironmentObject var manager: PSManager
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    /// The rect containing the sheet content
    @State var sheetContentRect: CGRect = .zero
    
    /// The offset for keyboard height
    @State var keyboardOffset: CGFloat = 0
    
    /// The offset for the drag gesture
    @State var dragOffset: CGFloat = 0

    /// The rect containing the presenter
    @State private var presenterContentRect: CGRect = .zero
    
    /// The point for the top anchor
    var topAnchor: CGFloat {
        let topSafeArea =  safeAreaInsets.top
        let calculatedTop =
        presenterContentRect.height +
        topSafeArea -
        sheetContentRect.height -
        handleSectionHeight
        
        return calculatedTop
    }
    
    /// The he point for the bottom anchor
    var bottomAnchor: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// The height of the handle bar section
    var handleSectionHeight: CGFloat {
        switch iPhoneStyle.handleBarStyle {
        case .solid: return 40
        case .none: return 0
        }
    }

    private var iPhoneStyle: PSIphoneStyle { manager.iPhoneStyle }
    private var iPadMacStyle: PSIpadMacStyle { manager.iPadMacStyle }
    
    /// Calculates the sheets y position
    private var sheetPosition: CGFloat {
        if self.manager.isPresented {
            let topInset = safeAreaInsets.top
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
    @ViewBuilder private var background: some View {
        switch deviceType {
        case .iphone:
            switch iPhoneStyle.background {
            case .solid(let color): Rectangle().fill(color)
            case .blur(let effect): Rectangle().fill(effect)
            case .gradient(let gradient): gradient
            }
        default:
            Rectangle().fill(iPadMacStyle.backgroundColor)
        }
    }
    
    // MARK: - Content Builders
    
    func body(content: Content) -> some View {
        ZStack {
            content
            // if the device type is an iPhone
                .iPhone {
                    $0
                        .trackFrame()
                        .onAppear {
                            addKeyboardNotifier()
                        }
                        .onDisappear {
                            removeKeyboardNotifier()
                        }
                        .onFrameDidChange { prefData in
                            withAnimation {
                                self.presenterContentRect = prefData.first?.bounds ?? .zero
                            }
                        }
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
        VStack(alignment: .leading, spacing: 0) {
            switch iPadMacStyle.closeButtonStyle {
            case .icon(image: let image, color: let color):
                HStack {
                    Spacer()
                    Button(action: {
                        self.manager.isPresented = false
                    }, label: {
                        image
                            .foregroundColor(color)
                    })
                }
                .padding()
            case .none:
                EmptyView()
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

        // content
        let sheetContent = self.manager.content
            .trackFrame()
        
        return ZStack {
            
            //MARK: - iPhone Cover View
            
            if manager.isPresented {
                Group {
                    switch iPhoneStyle.cover {
                    case .enabled(let color):
                        Rectangle()
                            .foregroundColor(color)
                    case .disabled:
                        EmptyView()
                    }
                }
                .edgesIgnoringSafeArea(.vertical)
                .onTapGesture { dismissSheet() }
            }
            
            // The SHEET VIEW
            Group {
                VStack(spacing: 0) {
                    switch iPhoneStyle.handleBarStyle {
                    case .solid(let handleBarColor):
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                                .frame(width: 40, height: 5)
                                .foregroundColor(handleBarColor)
                            Spacer()
                        }
                        .frame(height: handleSectionHeight)
                    case .none: EmptyView()
                    }

                    if case let PSType.scrollView(height, showsIndicators) = manager.type {
                        VStack {
                            PSScrollVIew(
                                axes: [.vertical],
                                showsIndicators: showsIndicators,
                                offsetChanged: {
                                    if $0.y > 60 { dismissSheet() }
                                }
                            ) {
                                sheetContent
                            }
                            .frame(height: height)
                            Spacer()
                        }
                    } else {
                        VStack {
                            sheetContent
                            Spacer()
                        }
                    }
                }
                .onFrameDidChange { prefData in
                    let animation = prefData.first?.bounds != nil ? self.manager.slideAnimation.slideIn : self.manager.slideAnimation.slideOut

                    guard let bounds = prefData.first?.bounds else {
                        withAnimation(animation) {
                            self.sheetContentRect = .zero
                        }
                        return
                    }

                    let sheetContentRect: CGRect
                    switch manager.type {
                    case .scrollView(height: let height, showsIndicators: _):
                        sheetContentRect = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: height)
                    case .dynamic:
                        sheetContentRect = bounds
                    }
                    withAnimation(animation) {
                        self.sheetContentRect = sheetContentRect
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(self.background)
                .cornerRadius(iPhoneStyle.cornerRadius)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
                .offset(y: self.sheetPosition)
                .onTapGesture {}
                .gesture(drag)
            }
        }
    }

    private func dismissSheet() {
        withAnimation(manager.slideAnimation.slideOut) {
            self.manager.isPresented = false
            self.dismissKeyboard()
            self.manager.onDismiss?()
        }
    }
}
