//
//  GetTokenResponse.swift
//  TestTask
//
//  Created by Olexander Markov on 04.08.2025.
//

import Foundation

struct GetTokenResponse: Decodable {
    let success: Bool
    let token: String
}
