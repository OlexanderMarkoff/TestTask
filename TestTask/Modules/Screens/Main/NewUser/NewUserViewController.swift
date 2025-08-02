//
//  NewUserViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class NewUserViewController: FormViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        let tabBarImage = Asset.bottombarSignUp.image.draw(text: "common.signup".localized)
        tabBarItem = UITabBarItem(
            title: "",
            image: tabBarImage,
            selectedImage: tabBarImage
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
        parent?.navigationItem.title = "screen.signup.title".localized
    }
}
