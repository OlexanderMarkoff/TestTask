//
//  NewUserViewCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import Foundation

final class NewUserViewCoordinator: BasicAppCoordinator {

    func primaryViewController() -> NewUserViewController {
        let viewModel = NewUserViewModel()

        let viewController = NewUserViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
