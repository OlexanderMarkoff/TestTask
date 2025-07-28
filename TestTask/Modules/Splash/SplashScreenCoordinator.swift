//
//  SplashCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import Foundation

final class SplashScreenCoordinator: BasicAppCoordinator {

    override func start() {
        let vc = SplashScreenViewController.instantiate()

        push(viewController: vc)
    }
}
