//
//  String+Localization.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import Foundation

extension String {
    public var localized: String {

        guard let bundlePath = Bundle.main.path(forResource: "en", ofType: "lproj"), let bundle = Bundle(path: bundlePath) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }

    public func localized(parameter: Int) -> String {
        let formatString = localized
        let resultString = String.localizedStringWithFormat(formatString, parameter)
        return resultString
    }

    public func localized(parameter: String) -> String {
        let formatString = localized
        let resultString = String.localizedStringWithFormat(formatString, parameter)
        return resultString
    }
}
