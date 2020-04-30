//
//  BlurEffectView.swift
//  PartialSheetExample
//
//  Created by Andrea Miotto on 30/4/20.
//  Copyright © 2020 Swift. All rights reserved.
//

import SwiftUI

/// An UIViewRepresentable for the UIBlurEffectView
struct BlurEffectView: UIViewRepresentable {

    /// The style of the Blut Effect View
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
