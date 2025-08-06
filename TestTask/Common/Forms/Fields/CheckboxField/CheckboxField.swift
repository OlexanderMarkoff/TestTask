//
//  CheckboxField.swift
//  TestTask
//
//  Created by Olexander Markov on 04.08.2025.
//

import UIKit

final class CheckboxField: FormField {

    var reuseIdentifier: String = "CheckboxCell"
    var nibName: String = "CheckboxCell"
    var tag: Int

    var model: CheckboxFieldModel {
        didSet {
            modelDidUpdate(model)
        }
    }

    private var modelDidUpdate: (CheckboxFieldModel) -> Void = { _ in }

    init(tag: Int, model: CheckboxFieldModel) {
        self.tag = tag
        self.model = model
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let checkboxCell = cell as? CheckboxCell else { return cell }
        checkboxCell.configure(with: model)
        modelDidUpdate = { [weak checkboxCell] in
            checkboxCell?.configure(with: $0)
        }

        return checkboxCell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
