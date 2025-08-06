//
//  InputCell.swift
//  TestTask
//
//  Created by Olexander Markov on 02.08.2025.
//

import UIKit

final class InputCell: UITableViewCell {

    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var messageLabel: UILabel!

    var textDidInput: ((String) -> Void)?

    private var cachedModel: InputFormFieldModel<String>?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        selectionStyle = .none
        messageLabel.applyStyle(.textBody3Light)
        messageLabel.text = ""

        inputText.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        inputText.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        inputText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        inputText.attributedPlaceholder = NSAttributedString(
              string: NSLocalizedString("titleKey", comment: "titleKey comment"),
              attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.48)]
            )

        inputText.layer.borderColor = UIColor.black.withAlphaComponent(0.48).cgColor
        inputText.layer.borderWidth = 1.0
        inputText.layer.cornerRadius = 8

        inputText.autocorrectionType = .no

        inputText.textColor = .testTaskBlack87
        inputText.font = FontFamily.NunitoSans.regular.font(size: 16.0)
    }

    func configure(with model: InputFormFieldModel<String>) {
        self.cachedModel = model
        inputText.placeholder = model.placeholder
        inputText.text = model.state.value
        inputText.keyboardType = model.keyboardType
        messageLabel.text = model.messageOfEmptyField
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        textDidInput?(textField.text ?? "")
    }

    @objc private func editingDidBegin() {
        inputText.layer.borderColor = UIColor.testTaskSecondary.cgColor
        messageLabel.textColor = .black.withAlphaComponent(0.6)
        messageLabel.text = cachedModel?.messageOfEmptyField
    }

    @objc private func editingDidEnd() {
        if let model = cachedModel, !model.state.isValid, !model.state.value.isEmpty {
            inputText.layer.borderColor = UIColor.black.withAlphaComponent(0.48).cgColor
            var error = ""
            for (index, message) in model.state.errorMessages.enumerated() {
                error.append(message)
                if index != 0 {
                    error.append("\n")
                }
            }
            messageLabel.text = error
            inputText.layer.borderColor = UIColor.testTaskErrorColor.cgColor
            messageLabel.textColor = .testTaskErrorColor
        } else {
            inputText.layer.borderColor = UIColor.black.withAlphaComponent(0.48).cgColor
            messageLabel.textColor = .black.withAlphaComponent(0.6)
            messageLabel.text = cachedModel?.messageOfEmptyField
        }
    }
}
