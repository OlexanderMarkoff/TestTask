//
//  ExisitngUsersCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import Foundation

final class ExisitngUsersCoordinator: BasicAppCoordinator {

    var reloadUsers: () -> Void = {}

    func primaryViewController() -> ExisitngUsersViewController {
        let viewModel = ExisitngUsersViewModel()
        reloadUsers = viewModel.reloadUsers

        let viewController = ExisitngUsersViewController()
        viewController.viewModel = viewModel
        viewController.fullyShownSection = viewModel.sectionFullyShown
        viewController.onRowSelected = viewModel.onRowSelected
        return viewController
    }
}
