//
//  NetworkClient.swift
//  TestTask
//
//  Created by Olexander Markov on 31.07.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String), parserError(reason: String)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason), .parserError(let reason):
            return reason
        }
    }
}

struct Activity: Decodable, CustomStringConvertible {
    var activity: String

    var description: String {
        return activity
    }
}

func fetch(request: URLRequest) async throws -> Data {
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIError.unknown
        }
        return data
    } catch let error {
        if let error = error as? APIError {
            throw error
        } else {
            throw APIError.apiError(reason: error.localizedDescription)
        }
    }
}

func fetch<T: Decodable>(request: URLRequest) async throws -> T {
    do {
        let data = try await fetch(request: request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(T.self, from: data)
    } catch let error {
        if let error = error as? DecodingError {
            var errorToReport = error.localizedDescription
            switch error {
            case .dataCorrupted(let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(
                    separator: "."
                )
                errorToReport = "\(context.debugDescription) - (\(details))"
            case .keyNotFound(let key, let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(
                    separator: "."
                )
                errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
            case .typeMismatch(let type, let context),
                    .valueNotFound(let type, let context):
                let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(
                    separator: "."
                )
                errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
            @unknown default:
                break
            }
            throw APIError.parserError(reason: errorToReport)
        } else {
            throw APIError.apiError(reason: error.localizedDescription)
        }
    }
}
