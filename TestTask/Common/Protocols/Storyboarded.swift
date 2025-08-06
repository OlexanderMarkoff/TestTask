//
//  Storyboarded.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {

        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboardName = className.replacingOccurrences(
            of: "ViewController",
            with: ""
        )
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)

        guard let vc = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("failed to instatiate \(className) from Storyboard")
        }
        return vc
    }
}
