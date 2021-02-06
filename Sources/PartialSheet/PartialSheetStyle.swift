//
//  PartialSheetStyle.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 21/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI


public struct PartialSheetStyle {

    /// Background enum
    public enum PartialSheetBackground {
        case solid(Color)
        case blur(UIBlurEffect.Style)
    }
    
    /// The background of the sheet
    var background: PartialSheetBackground

    /// The color of the Handlander Bar and the X button on ipad and mac
    var handlerBarColor: Color

    /// Tells if should be there a cover between the Partial Sheet and the Content
    var enableCover: Bool

    /// The color of the cover
    var coverColor: Color

    /// The blur effect style to applied between the partialSheet and the Presenter Conter
    var blurEffectStyle: UIBlurEffect.Style?

    /// The corner radius of Sheet
    var cornerRadius: CGFloat

    /// Minimum distance between the top of the sheet and the top of the screen
    var minTopDistance: CGFloat
  
    /// Inits the style
    ///
    /// - Parameters:
    ///   - background: The background to use
    ///   - handlerBarColor: The handlebar color
    ///   - enableCover: If the background cover is shown (behind the sheet)
    ///   - coverColor: The background cover color
    ///   - blurEffectStyle: A blur effect style to use on the background covor (behind the sheet)
    ///   - cornerRadius: The corner radius for the sheet
    ///   - minTopDistance: Minimum distance between the top of the sheet and the top of the screen
    public init(background: PartialSheetBackground,
                handlerBarColor: Color,
                enableCover: Bool,
                coverColor: Color,
                blurEffectStyle: UIBlurEffect.Style? = nil,
                cornerRadius: CGFloat,
                minTopDistance: CGFloat
    ) {
        self.background = background
        self.handlerBarColor = handlerBarColor
        self.enableCover = enableCover
        self.coverColor = coverColor
        self.cornerRadius = cornerRadius
        self.minTopDistance = minTopDistance
    }
}

extension PartialSheetStyle {

    /** A default Style for the PartialSheet with system colors.

     - background: .solid(Color(UIColor.tertiarySystemBackground))
     - handlerBarColor: Color(UIColor.systemGray2)
     - enableCover: true
     - coverColor: Color.black.opacity(0.4)
     - blurEffectStyle: nil
     */
    public static func defaultStyle() -> PartialSheetStyle {
        return PartialSheetStyle(background: .solid(Color(UIColor.tertiarySystemBackground)),
                                 handlerBarColor: Color(UIColor.systemGray2),
                                 enableCover: true,
                                 coverColor: Color.black.opacity(0.4),
                                 blurEffectStyle: nil,
                                 cornerRadius: 10,
                                 minTopDistance: 110
        )
    }
}
