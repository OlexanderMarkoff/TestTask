//
//  AppMessageField.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import UIKit

final class AppMessageField: FormField {
    let nibName = "AppMessageCell"
    let reuseIdentifier = "AppMessageCell"

    var tag: Int
    var model: AppMessageModel {
        didSet { modelDidUpdate(model) }
    }

    let buttonuttonTapped: () -> Void

    private var modelDidUpdate: (AppMessageModel) -> Void = { _ in }

    init(tag: Int, model: AppMessageModel, buttonuttonTapped: @escaping () -> Void) {
        self.tag = tag
        self.model = model
        self.buttonuttonTapped = buttonuttonTapped
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? AppMessageCell else { return cell }

        cell.configure(with: model)
        modelDidUpdate = cell.configure
        cell.actionButtonTapped = buttonuttonTapped
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        let insets = UIApplication.shared.keyWindow?.safeAreaInsets
        // 44 is nav bar height, 83 is tab har height. I know better to get if from views, but we have what we have ;)
        return UIScreen.main.bounds.size.height - (insets?.top ?? 0.0) - (insets?.bottom ?? 0.0) - 44 - 83
    }
}
