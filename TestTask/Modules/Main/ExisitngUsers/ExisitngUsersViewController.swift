//
//  ExisitngUsersViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class ExisitngUsersViewController: FormViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        let tabBarImage = Asset.bottombarUsers.image.draw(text: "common.users".localized)
        tabBarItem = UITabBarItem(
            title: nil,
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
        parent?.navigationItem.title = "screen.users.title".localized
    }
}
