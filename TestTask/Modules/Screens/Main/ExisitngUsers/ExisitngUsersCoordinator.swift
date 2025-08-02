//
//  ExisitngUsersCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import Foundation

final class ExisitngUsersCoordinator: BasicAppCoordinator {

    func primaryViewController() -> ExisitngUsersViewController {
        let viewModel = ExisitngUsersViewModel()

        let viewController = ExisitngUsersViewController()
        viewController.viewModel = viewModel
        viewController.fullyShownSection = viewModel.sectionFullyShown
        return viewController
    }
}
