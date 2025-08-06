//
//  ValidationRule.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import Foundation

protocol ValidationRule {
    func invalidMessage(forLabel name: String) -> String
    func apply<T>(to input: T) -> Bool
}
