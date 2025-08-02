//
//  TestTaskRequest.swift
//  TestTask
//
//  Created by Olexander Markov on 31.07.2025.
//

import Foundation

struct TestTaskRequest {

    let path: String
    let requestMethod: TestTaskRequestMethod
    let token: String?
    let bodyParams: [String: Any]?
    let queryparams: [String: String]?

    init(path: String, requestMethod: TestTaskRequestMethod,
         token: String? = nil, bodyParams: [String: Any]? = nil,
         queryparams: [String: String]? = nil) {
        self.path = path
        self.requestMethod = requestMethod
        self.token = token
        self.bodyParams = bodyParams
        self.queryparams = queryparams
    }

    private static var baseURL = "frontend-test-assignment-api.abz.agency"
    private static var apiVerstion = "/api/v1"

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = TestTaskRequest.baseURL
        components.path = TestTaskRequest.apiVerstion.appending(path)

        if let params = queryparams {
            var queryParams: [URLQueryItem] = []
            for key in params.keys {
                queryParams .append(URLQueryItem(name: key, value: params[key]))
            }
            components.queryItems = queryParams
        }

        return components.url
    }

    var request: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; application/json", forHTTPHeaderField: "Accept")
        request.addValue("UTF-8", forHTTPHeaderField: "Accept-Charset")
        request.httpMethod = requestMethod.rawValue

        if let token = token {
            request.addValue(token, forHTTPHeaderField: "token")
        }

        if let bodyParams = bodyParams, let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams) {
            request.httpBody = jsonData
        }
        return request
    }

    static func makeGetUsersReuest(page: Int, count: Int) -> TestTaskRequest {
        let params: [String: String] = [
            "page": "\(page)",
            "count": "\(count)"
        ]
        return TestTaskRequest(path: "/users", requestMethod: .get, queryparams: params)
    }
}

enum TestTaskRequestMethod: String {
    case get = "GET"
    case post = "POST"
}
