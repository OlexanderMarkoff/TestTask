//
//  LoadingViewDisplayer.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

protocol LoadingViewDisplayer {
    func displayLoadingView()
    func hideLoadingView()
}

extension LoadingViewDisplayer where Self: UIViewController {

    func displayLoadingView() {
        let loadingView = existingLoadingView() ?? createLoadingView()
        view.bringSubviewToFront(loadingView)
        loadingView.show()
    }

    func hideLoadingView() {
        hideExistingLoadingView()
    }

    // MARK: private
    private func existingLoadingView() -> LoadingView? {
        return view.subviews
            .compactMap { $0 as? LoadingView }
            .first
    }

    private func createLoadingView() -> LoadingView {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return loadingView
    }

    private func hideExistingLoadingView() {
        guard let loadingView = existingLoadingView() else {
            print("No LoadingView found for dismiss!")
            return
        }
        loadingView.hide()
    }
}
