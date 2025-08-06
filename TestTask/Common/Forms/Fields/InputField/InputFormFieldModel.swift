//
//  FormFieldModel.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import UIKit

struct InputFormFieldModel<T> {
    var placeholder: String = ""
    var messageOfEmptyField: String?
    var keyboardType: UIKeyboardType = .default
    var inputFieldConfiguration: FieldConfiguration?
    var rules: [ValidationRule] = []
    var format: (String?) -> String? = { return $0 }
    var state: InputState<T>
}

protocol FieldConfiguration {
    var isSelectionEntry: Bool { get }
    var validatesOnKeypress: Bool { get }
}
