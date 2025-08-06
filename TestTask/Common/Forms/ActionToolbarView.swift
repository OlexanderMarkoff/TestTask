//
//  ActionToolbarView.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

class ActionToolbarView: UIView {

    var actionButtonTapped: () -> Void = { print("actionButtonTapped not overridden") }

    lazy var actionButton: PrimaryActionButton = {
        let button = PrimaryActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        return button
    }()

    @objc private func didTapActionButton(_ sender: PrimaryActionButton) {
        actionButtonTapped()
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .testTaskBackground

        addSubview(actionButton)

        addConstraints([
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topSpacing),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: Constants.bottomSpacing)
        ])
    }

    func height() -> CGFloat {
        guard !actionButton.isHidden else { return 0}
        return Constants.topSpacing + Constants.bottomSpacing + Constants.buttonHeight
    }

    enum Constants {
        static let buttonHeight: CGFloat = 48
        static let topSpacing: CGFloat = 10
        static let bottomSpacing = topSpacing
    }
}
