//
//  TextViewWithPaddings.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import UIKit

final class TextViewWithPaddings: UITextField {

    let paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddings)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddings)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddings)
    }
}
