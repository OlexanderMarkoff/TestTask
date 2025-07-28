//
//  AppMessage.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

final class AppMessage {
    enum MessageType {
        case error
    }

    static let shared = AppMessage()
    private var currentView: UIView?
    private var timer: Timer!
    private var hideInterval: TimeInterval = 8.0
    let panGR = UIPanGestureRecognizer()
    var dismissAnimator: UIViewPropertyAnimator!
    var attributedString: NSAttributedString!
    var currentMessage: String = ""

    private init() {
        // properly init
        panGR.addTarget(self, action: #selector(viewDidPan(_:)))
    }

    private func prepareDismissAnimator(with translation: CGPoint) {
        dismissAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
        dismissAnimator.addAnimations {
            guard let view = self.currentView else { return }
            view.transform = CGAffineTransform.identity.concatenating(CGAffineTransform(translationX: 0, y: -view.bounds.height))
        }
        dismissAnimator.addCompletion { [weak self] completion in
            if completion == .end {
                self?.currentView = nil
            }
        }
        dismissAnimator.isUserInteractionEnabled = true
        dismissAnimator.isInterruptible = true
        dismissAnimator.startAnimation()
        dismissAnimator.pauseAnimation()
        guard let view = currentView else { return }

        if translation.y <= 0 {
            dismissAnimator.fractionComplete = -translation.y / view.bounds.height
        }
    }

    private func handleTranlationChange(_ translation: CGPoint) {
        guard let view = currentView else { return }
        if translation.y <= 0 {
            dismissAnimator.fractionComplete = -translation.y / view.bounds.height
        } else {
            dismissAnimator.fractionComplete = 0
        }
    }

    private func finalizeAnimator(with velocity: CGPoint) {
        let vector = CGVector(dx: 0, dy: velocity.y)
        let timing = UISpringTimingParameters(mass: 0.4, stiffness: 0.05, damping: 0.2, initialVelocity: vector)
        let completionSpeed = min(max(velocity.y, CGFloat(0.0)), CGFloat(1.0))

        let percentage = dismissAnimator.fractionComplete
        let durationFactor = min(1.0, (1.0 - (percentage * completionSpeed)))

        if percentage < 0.1 {
            dismissAnimator.isReversed.toggle()
        }
        dismissAnimator.continueAnimation(withTimingParameters: timing, durationFactor: durationFactor)
    }

    @objc func viewDidPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: currentView)
        switch sender.state {
        case .began:
            prepareDismissAnimator(with: translation)
        case .changed:
            handleTranlationChange(translation)
        case .cancelled, .ended:
            let velocity = sender.velocity(in: sender.view)
            finalizeAnimator(with: velocity)
        default:
            break
        }
    }

    func display(_ message: String, icon: UIImage? = nil, backgroundColor: UIColor = .red) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }

        let text = NSMutableAttributedString()
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        if let icon = icon {
            let attachment = NSTextAttachment()
            attachment.image = icon
            attachment.bounds = CGRect(x: 0, y: (font.capHeight - icon.size.height) / 2, width: icon.size.width, height: icon.size.height)
            let iconString = NSAttributedString(attachment: attachment)
            text.append(iconString)
        }

        let string = NSAttributedString(string: " " + message)
        text.append(string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        text.addAttributeToFullRange(.font, value: font)
        text.addAttributeToFullRange(.foregroundColor, value: UIColor.white)
        text.addAttributeToFullRange(.paragraphStyle, value: paragraphStyle)

        if message != currentMessage {
            currentMessage = message
            animateIn(attributedText: text, window: window, backgroundColor: backgroundColor)
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: self.hideInterval, repeats: false) { [weak self] _ in
                self?.hide { }
            }
        }
    }

    func animateIn(attributedText text: NSAttributedString, window keyWindow: UIWindow, backgroundColor: UIColor, hideAfter: TimeInterval = 8.0) {
        let topOffset = keyWindow.safeAreaInsets.top + 8
        guard let view = prepareView(attributedText: text, width: keyWindow.bounds.width, topOffset: topOffset) else { return }
        view.backgroundColor = backgroundColor
        let viewSize = view.systemLayoutSizeFitting(keyWindow.bounds.size)
        view.transform = CGAffineTransform.identity.concatenating(CGAffineTransform(translationX: 0, y: -viewSize.height))

        hide { [weak self] in
            self?.currentMessage = ""
            keyWindow.addSubview(view)
            self?.currentView = view
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut)
            animator.addAnimations {
                view.transform = .identity
            }
            animator.addCompletion { [weak self] _ in
                guard let self = self else { return }
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: self.hideInterval, repeats: false) { [weak self] _ in
                    self?.hide { }
                }
            }
            animator.startAnimation()
        }
    }

    func hide(completion: @escaping () -> Void) {
        guard let view = currentView else {
            completion()
            return
        }
        dismissAnimator?.stopAnimation(true)
        dismissAnimator?.finishAnimation(at: .end)

        dismissAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut)
        dismissAnimator.addAnimations {
            view.transform = CGAffineTransform.identity.concatenating(CGAffineTransform(translationX: 0, y: -view.bounds.height))
        }
        dismissAnimator.addCompletion { _ in
            view.removeGestureRecognizer(self.panGR)
            view.removeFromSuperview()
            self.currentView = nil
            completion()
        }
        dismissAnimator.isInterruptible = true
        dismissAnimator.isUserInteractionEnabled = true
        dismissAnimator.startAnimation()
    }

    func prepareView(attributedText: NSAttributedString, width: CGFloat, topOffset: CGFloat) -> UIView? {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = attributedText

        let handle = UIView(frame: .zero)
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.layer.cornerRadius = 2
        handle.layer.backgroundColor = UIColor(white: 1.0, alpha: 0.2).cgColor

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.addSubview(handle)

        view.addConstraints([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16),
            handle.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            handle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 60),
            handle.heightAnchor.constraint(equalToConstant: 4),
            view.bottomAnchor.constraint(equalTo: handle.bottomAnchor, constant: 8),
            view.widthAnchor.constraint(equalToConstant: width)
        ])
        view.addGestureRecognizer(panGR)

        return view
    }
}
