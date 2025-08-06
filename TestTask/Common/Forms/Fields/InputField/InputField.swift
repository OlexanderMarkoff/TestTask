//
//  InputField.swift
//  TestTask
//
//  Created by Olexander Markov on 03.08.2025.
//

import UIKit

final class InputField: FormField {

    var model: InputFormFieldModel<String> {
        didSet { modelDidUpdate(model) }
    }

    let reuseIdentifier: String = "InputCell"
    let nibName: String = "InputCell"
    let tag: Int

    var textDidInput: ((String) -> Void)?
    private var modelDidUpdate: (InputFormFieldModel<String>) -> Void = { _ in }

    init(tag: Int, model: InputFormFieldModel<String>, textInputCallback: ((String) -> Void)? = nil) {
        self.model = model
        self.tag = tag
        self.textDidInput = textInputCallback
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let c = cell as? InputCell else { return cell }
        c.configure(with: model)
        c.textDidInput = { [weak self] in
            self?.model.state.value = $0
            self?.textDidInput?($0)
        }
        modelDidUpdate = c.configure
        return c
    }

    @discardableResult
    func validate() -> Bool {
        model.state.errorMessages = []
        model.state.isValid = model.rules.allSatisfy { validationRule in
            let isValid = validationRule.apply(to: model.state.value)
            if !isValid {
                model.state.errorMessages.append(validationRule.invalidMessage(forLabel: model.placeholder))
            }
            return isValid
        }
        return model.state.isValid
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
