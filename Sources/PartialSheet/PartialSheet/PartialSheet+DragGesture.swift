//
//  PartialSheet+DragGesture.swift
//  PartialSheet+DragGesture
//
//  Created by Andrea Miotto on 15/09/21.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI

extension PartialSheet {
    /// Create a new **DragGesture** with *updating* and *onEndend* func
    func dragGesture() -> GestureStateGesture<_EndedGesture<_ChangedGesture<DragGesture>>, Bool> {
        DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
            .onChanged(onDragChanged)
            .onEnded(onDragEnded)
            .updating($isDetectingDrag) { value, state, transaction in
                state = true
            }
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
                UIScreen.main.bounds.height + self.handleSectionHeight
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
                withAnimation(manager.slideAnimation.defaultSlideAnimation) {
                    dragOffset = 0
                    self.manager.isPresented = false
                    self.manager.onDismiss?()
                }
            }
        } else if verticalDirection < 0 {
            withAnimation(manager.slideAnimation.defaultSlideAnimation) {
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
            
            withAnimation(manager.slideAnimation.defaultSlideAnimation) {
                dragOffset = 0
                self.manager.isPresented = (closestPosition == topAnchor)
                if !manager.isPresented {
                    manager.onDismiss?()
                }
            }
        }
    }
}
