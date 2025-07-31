//
//  AppMessageCell.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import UIKit

final class AppMessageCell: UITableViewCell {

    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!

    var actionButtonTapped: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        messageLabel.applyStyle(.textH1)
        messageButton.backgroundColor = .testTaskPrimary
        messageButton.layer.cornerRadius = 24

        messageButton.titleLabel?.applyStyle(.textBody2)
        messageButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)

    }

    func configure(with model: AppMessageModel) {
        messageImage.image = model.image
        messageLabel.text = model.message
        messageButton.titleLabel?.text = model.buttonTitle
    }

    @objc private func didTapActionButton() {
        actionButtonTapped()
    }
}
