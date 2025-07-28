//
//  TableBackedViewController.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

class TableBackedViewController: UIViewController, LoadingViewDisplayer {

    let refreshControl = UIRefreshControl()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .testTaskBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorColor = .clear
        return tableView
    }()

    weak var delegate: UITableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .testTaskBackground
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)

        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        // do not bounce when the content fits on the screen
        tableView.alwaysBounceVertical = false

        view.addConstraints([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func onRefresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
    }
}

extension TableBackedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
