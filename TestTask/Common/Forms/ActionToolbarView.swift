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
            actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            actionButton.heightAnchor.constraint(equalToConstant: 40.0),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 10.0),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 196.0)
        ])
    }
}
