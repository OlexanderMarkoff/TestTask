//
//  FormField.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

protocol FormField: AnyObject {
    var reuseIdentifier: String { get }
    var nibName: String { get }
    var tag: Int { get }

    @discardableResult
    func validate() -> Bool
    func reset()
    @discardableResult
    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController?) -> UITableViewCell
    func preferredHeight(for indexPath: IndexPath) -> CGFloat
}

extension FormField {
    @discardableResult
    func validate() -> Bool { true }

    func reset() {
        // do nothing
    }

    func configure(_ cell: UITableViewCell, indexPath: IndexPath, sender: FormViewController? = nil) -> UITableViewCell {
        return cell
    }

    func preferredHeight(for indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
