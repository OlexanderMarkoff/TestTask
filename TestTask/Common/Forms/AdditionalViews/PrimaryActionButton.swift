//
//  PrimaryActionButton.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

class PrimaryActionButton: UIButton {

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
        configuration = UIButton.Configuration.plain()
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 32, bottom: 12, trailing: 32)
        configurationUpdateHandler = UIButton.getConfiguration()
        layer.cornerRadius = 24
    }
}

extension UIButton {

    static func getConfiguration() -> UIButton.ConfigurationUpdateHandler {
        return { button in
            switch button.state {
            case [.selected, .highlighted]:
                button.backgroundColor = .testTaskHighlighted
                button.titleLabel?.applyStyle(.textBody2)
                button.setTitleColor(.testTaskBlack87, for: .highlighted)
            case .selected:
                button.backgroundColor = .testTaskHighlighted
                button.titleLabel?.applyStyle(.textBody2)
                button.setTitleColor(.testTaskBlack87, for: .highlighted)
            case .highlighted:
                button.backgroundColor = .testTaskHighlighted
                button.titleLabel?.applyStyle(.textBody2)
                button.setTitleColor(.testTaskBlack87, for: .highlighted)
            case .disabled:
                button.backgroundColor = .testTaskbuttonDissabled
                button.titleLabel?.applyStyle(.textBody2)
                button.setTitleColor(.black.withAlphaComponent(0.48), for: .disabled)
            default:
                button.backgroundColor = .testTaskPrimary
                button.titleLabel?.applyStyle(.textBody2)
                button.setTitleColor(.testTaskBlack87, for: .normal)
            }
        }
    }
}
