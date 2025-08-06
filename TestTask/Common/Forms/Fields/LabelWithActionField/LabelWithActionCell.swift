//
//  LabelWithActionCell.swift
//  TestTask
//
//  Created by Olexander Markov on 04.08.2025.
//

import UIKit

final class LabelWithActionCell: UITableViewCell {

    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    var actionTapped: () -> Void = { print("\(#file) - \(#line) - actionTapped isn't overriden") }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none

        mainContainer.layer.borderWidth = 1
        mainContainer.layer.cornerRadius = 8
        mainContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.48).cgColor

        titleLabel.applyStyle(.custom(color: .black.withAlphaComponent(0.48), font: FontFamily.NunitoSans.regular.font(size: 20)))

        actionLabel.applyStyle(.custom(color: .testTaskSecondary, font: FontFamily.NunitoSans.regular.font(size: 20)))

        actionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAction)))
        actionLabel.isUserInteractionEnabled = true

        messageLabel.applyStyle(.textBody3Light)
        messageLabel.text = ""
    }

    @objc private func didTapAction() {
        actionTapped()
    }

    func configure(with model: LabelWithActionFieldModel) {
        titleLabel.text = model.title
        actionLabel.text = model.action
        messageLabel.text = model.message

        if model.hasError {
            mainContainer.layer.borderColor = UIColor.testTaskErrorColor.cgColor
            messageLabel.textColor = .testTaskErrorColor
        } else {
            mainContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.48).cgColor
            messageLabel.textColor = .black.withAlphaComponent(0.6)
        }
    }
}
