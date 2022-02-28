//
//  PartialSheet+Keyboard.swift
//  PartialSheet+Keyboard
//
//  Created by Andrea Miotto on 15/09/21.
//  Copyright © 2021 Swift. All rights reserved.
//

import SwiftUI

// MARK: - Keyboard Handles Methods
extension PartialSheet {
    /// Remove the keyboard offset
    func removeKeyboardNotifier() {
        let notifier = NotificationCenter.default
        notifier.removeObserver(self)
    }

    /// Add the keyboard notifier
    func addKeyboardNotifier() {
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

    /// Dismiss the keyboard
    func dismissKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
        }
    }

    /// Add the keyboard offset
    private func keyboardShow(notification: Notification) {
        let endFrame = UIResponder.keyboardFrameEndUserInfoKey
        if let rect: CGRect = notification.userInfo![endFrame] as? CGRect {
            let height = rect.height
            let bottomInset = safeAreaInsets.bottom
            withAnimation(manager.slideAnimation.defaultSlideAnimation) {
                self.keyboardOffset = height - bottomInset
            }
        }
    }

    /// Remove the keyboard offset
    private func keyboardHide(notification: Notification) {
        DispatchQueue.main.async {
            withAnimation(manager.slideAnimation.defaultSlideAnimation) {
                self.keyboardOffset = 0
            }
        }
    }
}
