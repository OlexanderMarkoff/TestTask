//
//  UIViewController+Keyboard.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

extension UIViewController {

    func startMonitoringKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func stopMonitoringKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Override this function to animate the view with the keyboard height
    @objc func animateKeyboardHeight(to height: CGFloat) {
        print("Method `animateKeyboardHeight` not overriden by \(description).", "Keyboard height = \(height).")
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        animateKeyboardHeight(to: keyboardHeight)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        print("Method `animateKeyboardHeight(to: CGFloat)` will be triggered with value = `0`.")
        print("Notification: \(notification).")
        animateKeyboardHeight(to: 0)
    }

    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap(delegate: UIGestureRecognizerDelegate) {
        self.view.addGestureRecognizer(self.endEditingRecognizer(delegate: delegate))
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer(delegate: delegate))
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer(delegate: UIGestureRecognizerDelegate) -> UIGestureRecognizer {
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
            tap.delegate = delegate
            tap.cancelsTouchesInView = false
            return tap
        }
}
