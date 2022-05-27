//
//  PSIphoneStyle.swift
//
//  Created by Andrea Miotto on 21/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI


public struct PSIphoneStyle {
    /// Background types
    public enum PSIphoneBackground {
        case solid(Color)
        case blur(Material)
        case gradient(LinearGradient)
    }

    /// Handle Bar types
    public enum PSHandleBarStyle {
        case solid(Color)
        case none
    }

    /// Cover types
    public enum PSCoverStyle {
        case enabled(Color)
        case disabled
    }
    
    /// The background color of the sheet
    var background: PSIphoneBackground

    /// The style of the Handle Bar
    var handleBarStyle: PSHandleBarStyle

    /// The style of the Handle Bar
    var cover: PSCoverStyle

    /// The corner radius of Sheet
    var cornerRadius: CGFloat
    
    /// Inits the style
    ///
    /// - Parameters:
    ///   - background: The background to use
    ///   - handleBarStyle: The handlebar style
    ///   - cover: The background cover color
    ///   - cornerRadius: The corner radius for the sheet
    public init(background: PSIphoneBackground,
                handleBarStyle: PSHandleBarStyle,
                cover: PSCoverStyle,
                cornerRadius: CGFloat
    ) {
        self.background = background
        self.handleBarStyle = handleBarStyle
        self.cover = cover
        self.cornerRadius = cornerRadius
    }
}

extension PSIphoneStyle {

    /** A default Style for the PSIphoneTheme with system colors.

     - background: .solid(Color(UIColor.systemBackground))
     - handleBarStyle: .solid(Color.secondary)
     - cover: .enabled(Color.black.opacity(0.4))
     - cornerRadius: 10
     */
    public static func defaultStyle() -> PSIphoneStyle {
        return .init(background: .solid(Color(UIColor.systemBackground)),
                             handleBarStyle: .solid(Color.secondary),
                             cover: .enabled(Color.black.opacity(0.4)),
                             cornerRadius: 10
        )
    }
}
