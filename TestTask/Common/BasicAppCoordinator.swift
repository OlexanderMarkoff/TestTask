//
//  BasicAppCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

class BasicAppCoordinator {

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

    func start() {

    }

    func start(subCoordinator: BasicAppCoordinator) {
        self.subCoordinator = subCoordinator
        self.subCoordinator?.start()
    }

    func completeSubWorkflow() {
        self.subCoordinator = nil
    }

    func start(viewController: UIViewController) {

    }

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

    deinit {
        print("--- \(self) deinit")
    }
}
