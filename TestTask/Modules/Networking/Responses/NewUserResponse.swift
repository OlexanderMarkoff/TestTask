//
//  NewUserResponse.swift
//  TestTask
//
//  Created by Olexander Markov on 05.08.2025.
//

import Foundation

struct NewUserResponse: Decodable {

    let success: Bool
    let userId: Int
    let message: String
    let fails: NewUserFailsResponse?

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case userId = "user_id"
        case message = "message"
        case fails = "fails"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        userId = (try? values.decode(Int.self, forKey: .success)) ?? -1
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        fails = (try? values.decode(NewUserFailsResponse.self, forKey: .fails))
    }
}

struct NewUserFailsResponse: Decodable {
    let name: [String]?
    let email: [String]?
    let phone: [String]?
    let position_id: [String]?
    let photo: [String]?

    func getErrors() -> String {
        var error = ""
        error.append(makeErrorString(errors: name))
        error.append(makeErrorString(errors: email))
        error.append(makeErrorString(errors: phone))
        error.append(makeErrorString(errors: position_id))
        error.append(makeErrorString(errors: photo))
        return error
    }

    private func makeErrorString(errors: [String]?) -> String {
        var errStr = ""
        errors?.forEach {item in
            errStr.append(item)
            errStr.append("\n")
        }

        return errStr
    }
}
