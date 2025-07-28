//
//  UIView+fromNib.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

extension UIView {

    class func fromNib<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T else {
            fatalError("could not load Nib from bundle using fromNib()")
        }
        return view
    }
}
