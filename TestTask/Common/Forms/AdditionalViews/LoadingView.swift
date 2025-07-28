//
//  LoadingView.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

final class LoadingView: UIView {
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    lazy var overlayView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let activityIndicator = UIActivityIndicatorView(style: .large)

    let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMessage(_ message: String?) {
        guard let message = message, !message.isEmpty else { return }
        messageLabel.text = message
        stackView.addArrangedSubview(messageLabel)
    }

    func commonSetup() {
        addSubview(overlayView)
        addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.color = .testTaskLoader

        addConstraints([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20)
        ])
    }

    func show() {
        isHidden = false
        activityIndicator.startAnimating()
        animator.addAnimations {
            self.overlayView.effect = UIBlurEffect(style: .dark)
        }
        if !animator.isRunning {
            animator.startAnimation()
        }
    }

    func hide() {
        animator.addAnimations {
            self.overlayView.effect = nil
        }
        animator.addCompletion { _ in
            self.isHidden = true
            self.activityIndicator.stopAnimating()
        }
        if !animator.isRunning {
            animator.startAnimation()
        }
    }
}
