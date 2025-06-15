//
//  KeyboardHandling.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

protocol KeyboardHandling: AnyObject {
    var scrollViewToAdjust: UIScrollView { get }
    func registerForKeyboardNotifications()
    func unregisterForKeyboardNotifications()
}

extension KeyboardHandling where Self: UIViewController {

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let bottomInset = keyboardFrame.height - self.view.safeAreaInsets.bottom
        scrollViewToAdjust.contentInset.bottom = bottomInset + 16
        scrollViewToAdjust.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    private func keyboardWillHide(_ notification: Notification) {
        scrollViewToAdjust.contentInset.bottom = 0
        scrollViewToAdjust.verticalScrollIndicatorInsets = .zero
    }
}