//
//  PrimaryActionButton.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

class PrimaryActionButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .testTaskPrimary : .testTaskGray
            setNeedsDisplay()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }

    private func commonSetup() {
        backgroundColor = .testTaskBackground
        titleLabel?.font = FontFamily.NunitoSans.regular.font(size: 18)
    }

}
