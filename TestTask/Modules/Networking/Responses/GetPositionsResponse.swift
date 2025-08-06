//
//  GetPositionsResponse.swift
//  TestTask
//
//  Created by Olexander Markov on 04.08.2025.
//

import Foundation

struct PositionsResponse: Decodable {
    let success: Bool
    let positions: [PositionResponse]
}

struct PositionResponse: Decodable {
    let id: Int
    let name: String
}
