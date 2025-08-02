//
//  TextStyle.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

enum TextStyle {
    case textH1
    case textBody1
    case textBody2
    case textBody3
    case textBody3Light

    case custom(color: UIColor = .black.withAlphaComponent(0.87), font: UIFont = FontFamily.NunitoSans.regular.font(size: 14.0))
}
