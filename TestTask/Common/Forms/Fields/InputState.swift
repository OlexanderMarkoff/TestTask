//
//  InputState.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import UIKit

final class InputState<T> {
    var value: T
    var isValid: Bool = true
    var errorMessages: [String] = []
    var selectedTextRange: UITextRange?

    private var initialValue: T

    init(value: T) {
        initialValue = value
        self.value = value
    }

    func reset() {
        value = initialValue
        isValid = true
        errorMessages = []
        selectedTextRange = nil
    }

}
