//
//  AppMessageViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import UIKit

final class AppMessageViewController: FormViewController {

    let hasCloseButton: Bool

    init(title: String = "", hasCloseButton: Bool = false) {
        self.hasCloseButton = hasCloseButton
        super.init(nibName: nil, bundle: nil)
        self.title = title
        configureNavBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if hasCloseButton {
            let button = UIButton(type: .custom)
            button.setImage(Asset.navBarClose.image, for: .normal)
            button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
            let close = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItems = [close]
        }
    }

    private func configureNavBar() {
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.backgroundColor = .white

        navigationBarAppearace.titleTextAttributes = [
            NSAttributedString.Key.font: FontFamily.NunitoSans.regular.font(size: 20) ?? UIFont.systemFont(ofSize: 20.0),
            NSAttributedString.Key.foregroundColor: UIColor.testTaskBlack87]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barTintColor = UIColor.white

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)

        tableView.isScrollEnabled = false
    }

    @objc func didTapCloseButton() {
        closeAction()
    }

}
