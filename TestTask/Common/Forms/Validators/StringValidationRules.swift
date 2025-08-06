//
//  StringValidationRules.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import Foundation

enum StringValidationRules: ValidationRule {
    case exactLength(Int)
    case minLength(Int)
    case maxLength(Int)
    case lengthBetween(ClosedRange<Int>)
    case notEmpty
    case isAlphanumeric
    case isValidEmailAddress
    case isValidPhoneNumber

    func invalidMessage(forLabel name: String) -> String {
        switch self {
        case .exactLength(let count):
            return "error.length_not_exact".localized(parameter: count)
        case .minLength(let count):
            return "error.length_too_short".localized(parameter: count)
        case .maxLength(let count):
            return "error.length_too_long".localized(parameter: count)
        case .lengthBetween(let range):
            return "error.length_not_in_range".localized(arguments: ["\(range.lowerBound)", "\(range.upperBound)"])
        case .isAlphanumeric:
            return "error.not_alphanumeric".localized
        case .notEmpty:
            return "error.empty".localized
        case .isValidEmailAddress:
            return "error.invalid_email".localized
        case .isValidPhoneNumber:
            return "error.invalid_phone".localized
        }
    }

    func apply<T>(to input: T) -> Bool {
        guard let input = input as? String else { return false }
        switch self {
        case .exactLength(let count):
            return input.count == count
        case .minLength(let count):
            return input.count >= count
        case .maxLength(let count):
            return input.count <= count
        case .isAlphanumeric:
            return isAlphanumericText(input)
        case .lengthBetween(let range):
            return input.count >= range.lowerBound && input.count <= range.upperBound
        case .notEmpty:
            return !input.isEmpty
        case .isValidEmailAddress:
            return isValidEmail(input)
        case .isValidPhoneNumber:
            return isValidPhone(input)
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^\\+380[3-9][0-9]{8}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone.clearPhoneNumber())
    }

    private func isAlphanumericText(_ text: String) -> Bool {
        for ch in text.unicodeScalars {
            guard CharacterSet.alphanumerics.contains(ch) else {
                return false
            }
        }
        return true
    }

}
