//
//  BasicAppCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit
import Foundation

class BasicAppCoordinator: ConnectionObserver {

    weak var navigationController: UINavigationController?
    weak var parentCoordinator: BasicAppCoordinator?
    var subCoordinator: BasicAppCoordinator?

    var completion: () -> Void = {}

    init(navigationController: UINavigationController?, completion: (() -> Void)?) {
        self.navigationController = navigationController

        if let completion = completion {
            self.completion = completion
        }
    }

    convenience init(viewController: UIViewController, completion: (() -> Void)?) {
        self.init(navigationController: viewController.navigationController, completion: completion)
    }

    convenience init(parentCoordinator: BasicAppCoordinator) {
        self.init(navigationController: parentCoordinator.navigationController, completion: parentCoordinator.completion)
        if parentCoordinator.subCoordinator != nil {
            parentCoordinator.subCoordinator = nil
        }
        parentCoordinator.subCoordinator = self
        self.parentCoordinator = parentCoordinator
    }

    func start() {}

    func start(subCoordinator: BasicAppCoordinator) {
        self.subCoordinator = subCoordinator
        self.subCoordinator?.start()
    }

    func completeSubWorkflow() {
        self.subCoordinator = nil
    }

    func start(viewController: UIViewController) {}

    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }

    func push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
        finishWorkflow()
    }

    func finishWorkflow() {
        if let parentWorkflow = parentCoordinator {
            parentWorkflow.completeSubWorkflow()
        } else {
            completeSubWorkflow()
            completion()
        }
    }

    func observeNetwork() {
        NetworkMonitor.shared.addConnectionObserver(observer: self)
    }

    func connectionChanged(isConnected: Bool) {
        if !isConnected {
            MainThread.run { [weak self] in
                self?.presentNoNetworkScreen()
            }
        }
    }

    func presentNoNetworkScreen(_ completion: @escaping () -> Void = {}) {
        let viewModel = AppMessageViewModel(appMessageModel: .noNetwork)

        let viewController = AppMessageViewController()
        viewController.viewModel = viewModel
        let navC = UINavigationController(rootViewController: viewController)
        navC.modalPresentationStyle = .fullScreen
        viewController.closeAction = {
            if NetworkMonitor.shared.isConnected {
                navC.dismiss(animated: true)
                completion()
            } else {
                viewModel.updateCallback?("no_connection_yet".localized)
            }
        }

        viewModel.actionButtonuttonTapped = {
            if NetworkMonitor.shared.isConnected {
                navC.dismiss(animated: true)
                completion()
            } else {
                viewModel.updateCallback?("no_connection_yet".localized)
            }
        }

        present(viewController: navC)
    }

    func presentInfoScreen(_ appMessageModel: AppMessageModel, hasCloseButton: Bool = true, _ completion: @escaping () -> Void = {}) {
        let viewModel = AppMessageViewModel(appMessageModel: appMessageModel)

        let viewController = AppMessageViewController(hasCloseButton: hasCloseButton)
        viewController.viewModel = viewModel
        let navC = UINavigationController(rootViewController: viewController)
        navC.modalPresentationStyle = .fullScreen
        viewController.closeAction = {
            navC.dismiss(animated: true)
            completion()
        }

        viewModel.actionButtonuttonTapped = {
            navC.dismiss(animated: true)
            completion()
        }

        parentCoordinator?.present(viewController: navC)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    public static func == (lhs: BasicAppCoordinator, rhs: BasicAppCoordinator) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    deinit {
        NetworkMonitor.shared.removeConnectionObserver(observer: self)
        print("--- \(self) deinit")
    }
}
