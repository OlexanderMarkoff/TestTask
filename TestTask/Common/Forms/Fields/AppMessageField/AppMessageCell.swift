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
        messageButton.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }

    func configure(with model: AppMessageModel) {
        messageImage.image = model.image
        messageLabel.text = model.message
        messageButton.isHidden = model.hideButton
        messageButton.setTitle(model.buttonTitle, for: .normal)

    }

    @objc private func didTapActionButton() {
        actionButtonTapped()
    }
}
