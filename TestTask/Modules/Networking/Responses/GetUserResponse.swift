//
//  GetUserResponse.swift
//  TestTask
//
//  Created by Olexander Markov on 31.07.2025.
//

import Foundation

struct UsersPage: Decodable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let links: UserLinksResponse
    let users: [UserResponse]

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case page = "page"
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case count = "count"
        case links = "links"
        case users = "users"
    }
}

struct UserLinksResponse: Decodable {
    let nextUrl: String?
    let prevUrl: String?

    enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
    }
}

struct UserResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Date
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case position = "position"
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo = "photo"
    }
}
