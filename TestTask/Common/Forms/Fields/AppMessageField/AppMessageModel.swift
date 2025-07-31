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

    static let `noNetwork` = AppMessageModel(image: Asset.noNetworkImage.image,
                                           message: "no_connection.message".localized,
                                           buttonTitle: "common.try_again".localized)
}
