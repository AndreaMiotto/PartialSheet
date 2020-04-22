//
//  PartialSheetStyle.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 21/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

public struct PartialSheetStyle {

    /// The color of the background
    var backgroundColor: Color

    /// The color of the Handlander Bar and the X button on ipad and mac
    var handlerBarColor: Color

    /// Tells if should be there a cover between the Partial Sheet and the Content
    var enableCover: Bool

    /// The color of the cover
    var coverColor: Color

    public init(backgroundColor: Color, handlerBarColor: Color, enableCover: Bool, coverColor: Color) {
        self.backgroundColor = backgroundColor
        self.handlerBarColor = handlerBarColor
        self.enableCover = enableCover
        self.coverColor = coverColor
    }
}

extension PartialSheetStyle {

    /** A default Style for the PartialSheet with system colors.

     - backgroundColor: Color(UIColor.tertiarySystemBackground)
     - handlerBarColor: Color(UIColor.systemGray2)
     - enableCover: true
     - coverColor: Color.black.opacity(0.4)
     */
    public static func defaultStyle() -> PartialSheetStyle {
        return PartialSheetStyle(backgroundColor: Color(UIColor.tertiarySystemBackground),
                                 handlerBarColor: Color(UIColor.systemGray2),
                                 enableCover: true,
                                 coverColor: Color.black.opacity(0.4)
        )
    }
}
