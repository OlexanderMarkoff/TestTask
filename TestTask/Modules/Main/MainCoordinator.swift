//
//  MainCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class MainCoordinator: BasicAppCoordinator {

    lazy var exisitngUsersCoordinator: ExisitngUsersCoordinator = {
        return ExisitngUsersCoordinator(parentCoordinator: self)
    }()

    lazy var newUserViewCoordinator: NewUserViewCoordinator = {
        return NewUserViewCoordinator(parentCoordinator: self)
    }()

    lazy var mainController: MainViewController = {
        let mainController = MainViewController()

        mainController.viewControllers =  [
                exisitngUsersCoordinator.primaryViewController(),
                newUserViewCoordinator.primaryViewController()
            ]
        return mainController
    }()

    override func start() {
        let navC = UINavigationController(rootViewController: mainController)
        navC.modalPresentationStyle = .fullScreen
        present(viewController: navC)
        navigationController = navC
    }

}
