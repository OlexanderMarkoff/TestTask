//
//  TestTaskColors.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

extension UIColor {
    func resolvedColorFallback(with traitCollection: UITraitCollection) -> UIColor {
        if #available(iOS 13.0, *) {
            return self.resolvedColor(with: traitCollection)
        } else {
            return self
        }
    }

    @nonobjc class var testTaskPrimary: UIColor {
        return UIColor(named: "colorPrimary")!
    }

    @nonobjc class var testTaskSecondary: UIColor {
        return UIColor(named: "colorSecondary")!
    }

    @nonobjc class var testTaskBackground: UIColor {
        return UIColor(named: "colorBackground")!
    }

    @nonobjc class var testTaskGray: UIColor {
        return UIColor(named: "colorGray")!
    }

    @nonobjc class var testTaskLoader: UIColor {
        return UIColor(named: "colorGray")!
    }

    @nonobjc class var testTaskTabBarBackground: UIColor {
        return UIColor(named: "tabBarBackground")!
    }

    @nonobjc class var testTaskBlack60: UIColor {
        return UIColor(named: "black60")!
    }

    @nonobjc class var testTaskBlack87: UIColor {
        return UIColor(named: "black87")!
    }

}
