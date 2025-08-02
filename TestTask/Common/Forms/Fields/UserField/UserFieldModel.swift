//
//  UserFieldModel.swift
//  TestTask
//
//  Created by Olexander Markov on 01.08.2025.
//

import Foundation

struct UserFieldModel {

    let avatarUrl: String
    let userName: String
    let userPosition: String
    let userMail: String
    let userPhone: String

    init(userResponse: UserResponse) {
        self.avatarUrl = userResponse.photo
        self.userName = userResponse.name
        self.userPosition = userResponse.position
        self.userMail = userResponse.email
        self.userPhone = userResponse.phone
    }

}
