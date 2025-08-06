//
//  AppMessageModel.swift
//  TestTask
//
//  Created by Olexander Markov on 30.07.2025.
//

import UIKit

struct AppMessageModel {
    let image: UIImage
    let message: String
    let buttonTitle: String
    let hideButton: Bool

    static let `noNetwork` = AppMessageModel(image: Asset.noNetworkImage.image,
                                             message: "message.no_connection".localized,
                                             buttonTitle: "common.try_again".localized,
                                             hideButton: false)

    static let `noUsers` = AppMessageModel(image: Asset.noUsers.image,
                                           message: "message.no_users".localized,
                                           buttonTitle: "",
                                           hideButton: true)

    static let `registrationSuccess` = AppMessageModel(image: Asset.successImage.image,
                                           message: "message.user_registered".localized,
                                                       buttonTitle: "common.got_it".localized,
                                           hideButton: false)
}
