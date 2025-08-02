//
//  ExisitngUsersViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class ExisitngUsersViewController: FormViewController {

    var fullyShownSection: (Int) -> Void = { _ in print("fullyshownSection is not overridden") }

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (viewModel?.sections[indexPath.section].cells.count ?? 0) - 1 == indexPath.row {
            fullyShownSection(indexPath.section)
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
