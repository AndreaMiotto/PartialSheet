//
//  PSIpadMacStyle.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 21/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

public struct PSIpadMacStyle {
    /// Close Button types
    public enum PSIpadMacCloseButtonStyle {
        case icon(image: Image, color: Color)
        case none
    }

    /// The background color
    var backgroundColor: Color

    /// The close button
    var closeButtonStyle: PSIpadMacCloseButtonStyle

    /// Inits the style
    ///
    /// - Parameters:
    ///   - backgroundColor: The background color to use
    ///   - closeButtonStyle: The close button style
    public init(backgroundColor: Color,
                closeButtonStyle: PSIpadMacCloseButtonStyle
    ) {
        self.backgroundColor = backgroundColor
        self.closeButtonStyle = closeButtonStyle
    }
}

extension PSIpadMacStyle {

    /** A default Style for the PSIpadMacTheme with system colors.

     - backgroundColor: .Color(UIColor.tertiarySystemBackground)
     - handleBarColor: .icon(image: Image(systemName: "xmark"), color: Color.secondary)
     */
    public static func defaultStyle() -> PSIpadMacStyle {
        .init(backgroundColor: Color(UIColor.systemBackground),
              closeButtonStyle: .icon(image: Image(systemName: "xmark"), color: Color.secondary)
        )
    }
}
