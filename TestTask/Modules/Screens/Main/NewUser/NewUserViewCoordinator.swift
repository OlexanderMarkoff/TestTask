//
//  NewUserViewCoordinator.swift
//  TestTask
//
//  Created by Olexander Markov on 29.07.2025.
//

import UIKit

final class NewUserViewCoordinator: BasicAppCoordinator {

    var userCreated: () -> Void = {}

    func primaryViewController() -> NewUserViewController {
        let viewModel = NewUserViewModel()
        viewModel.showErrorScreen = { [weak self] in
            self?.presentInfoScreen(AppMessageModel(image: Asset.failImage.image,
                                                    message: $0,
                                                    buttonTitle: "common.try_again".localized,
                                                    hideButton: false))
        }

        viewModel.showSucessScreen = { [weak self] in
            self?.presentInfoScreen(.registrationSuccess)
            self?.userCreated()
        }

        let viewController = NewUserViewController()
        viewController.viewModel = viewModel
        viewController.onRowSelected = viewModel.onRowSelected

        viewModel.requestPhotoPicker = viewController.presentPickPhotoSheet
        return viewController
    }
}
