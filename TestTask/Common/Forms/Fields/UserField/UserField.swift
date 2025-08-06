//
//  UserField.swift
//  TestTask
//
//  Created by Olexander Markov on 01.08.2025.
//

import UIKit

final class UserField: FormField {

    let nibName = "UserCell"
    let reuseIdentifier = "UserCell"

    var tag: Int
    var model: UserFieldModel {
        didSet { modelDidUpdate(model) }
    }

    private var modelDidUpdate: (UserFieldModel) -> Void = { _ in }

    init(tag: Int, model: UserFieldModel) {
        self.tag = tag
        self.model = model
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell {
        guard let cell = cell as? UserCell else { return cell }

        cell.configure(with: model)
        modelDidUpdate = cell.configure
        return cell
    }

}
