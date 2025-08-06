//
//  LabelWithActionField.swift
//  TestTask
//
//  Created by Olexander Markov on 04.08.2025.
//

import UIKit

final class LabelWithActionField: FormField {

    var model: LabelWithActionFieldModel {
        didSet { modelDidUpdate(model) }
    }

    var reuseIdentifier: String = "LabelWithActionCell"
    var nibName: String = "LabelWithActionCell"
    var tag: Int

    private var modelDidUpdate: (LabelWithActionFieldModel) -> Void = { _ in }
    let actionDidTap: () -> Void

    init(tag: Int, model: LabelWithActionFieldModel, actionDidTap: @escaping () -> Void = {}) {
        self.tag = tag
        self.model = model
        self.actionDidTap = actionDidTap
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        guard let labelWithActionCell = cell as? LabelWithActionCell else { return cell }
        labelWithActionCell.configure(with: model)
        modelDidUpdate = labelWithActionCell.configure
        labelWithActionCell.actionTapped = actionDidTap
        return labelWithActionCell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
