//
//  LoadingViewDisplayer.swift
//  TestTask
//
//  Created by Olexander Markov on 28.07.2025.
//

import UIKit

protocol LoadingViewDisplayer {
    func displayLoadingView()
    func displayLoadingView(message: String?)
    func hideLoadingView()
}

extension LoadingViewDisplayer where Self: UIViewController {

    func displayLoadingView() {
        displayLoadingView(message: nil)
    }

    func displayLoadingView(message: String? = nil) {
        let loadingView = existingLoadingView() ?? createLoadingView(message: message)
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

    private func createLoadingView(message: String?) -> LoadingView {
        let loadingView = LoadingView()
        loadingView.setMessage(message)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
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
