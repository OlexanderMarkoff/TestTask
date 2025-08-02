//
//  MainViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureNavBar()
    }

    private func configureTabBar() {
        tabBar.backgroundColor = .testTaskTabBarBackground
        tabBar.unselectedItemTintColor = .testTaskBlack60
        tabBar.tintColor = .testTaskSecondary
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().backgroundColor = .testTaskPrimary
    }

    private func configureNavBar() {
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.backgroundColor = .testTaskPrimary

        navigationBarAppearace.titleTextAttributes = [
            NSAttributedString.Key.font: FontFamily.NunitoSans.regular.font(size: 20) ?? UIFont.systemFont(ofSize: 20.0),
            NSAttributedString.Key.foregroundColor: UIColor.testTaskBlack87]
    }
}
