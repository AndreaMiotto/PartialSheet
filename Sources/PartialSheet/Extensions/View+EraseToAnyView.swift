//
//  View+EraseToAnyView.swift
//  View+EraseToAnyView
//
//  Created by Andrea Miotto on 15/09/21.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI

extension View {
    /// Wrap the current view into an **AnyView**
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
