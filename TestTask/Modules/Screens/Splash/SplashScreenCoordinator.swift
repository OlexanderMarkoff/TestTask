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
        vc.goToMain = checkNetwork

        push(viewController: vc)
    }

    private func checkNetwork() {
        if NetworkMonitor.shared.isConnected {
            presentMainScreen()
        } else {
            presentInfoScreen(presentMainScreen)
        }
    }

    private func presentMainScreen() {
        let coordinator =  MainCoordinator(parentCoordinator: self)
        coordinator.start()
    }
}
