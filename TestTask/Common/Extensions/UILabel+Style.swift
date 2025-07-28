//
//  UILabel+Style.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

extension UILabel {

    func applyStyle(_ style: TextStyle) {
        switch style {
        case .textH1:
            textColor = .black.withAlphaComponent(87)
            font = FontFamily.NunitoSans.regular.font(size: 20)
        case .textBody1:
            textColor = .black.withAlphaComponent(87)
            font = FontFamily.NunitoSans.regular.font(size: 16)
        case .textBody2:
            textColor = .black.withAlphaComponent(87)
            font = FontFamily.NunitoSans.regular.font(size: 18)
        case .textBody3:
            textColor = .black.withAlphaComponent(87)
            font = FontFamily.NunitoSans.regular.font(size: 14)
        case .textBody3Light:
            textColor = .black.withAlphaComponent(60)
            font = FontFamily.NunitoSans.regular.font(size: 14)
        case .custom(let color, let font):
            textColor = color
            self.font = font
        }
    }
}
