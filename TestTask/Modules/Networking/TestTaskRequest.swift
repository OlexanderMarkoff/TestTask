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
    let queryParams: [String: String]?
    let bodyParams: [String: String]?
    let binaryParams: [String: Data]?

    init(path: String, requestMethod: TestTaskRequestMethod,
         token: String? = nil, queryParams: [String: String]? = nil,
         bodyParams: [String: String]? = nil, binaryParams: [String: Data]? = nil) {
        self.path = path
        self.requestMethod = requestMethod
        self.token = token
        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.binaryParams = binaryParams
    }

    private static var baseURL = "frontend-test-assignment-api.abz.agency"
    private static var apiVerstion = "/api/v1"

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = TestTaskRequest.baseURL
        components.path = TestTaskRequest.apiVerstion.appending(path)

        if let params = queryParams {
            var queryParams: [URLQueryItem] = []
            for key in params.keys {
                queryParams .append(URLQueryItem(name: key, value: params[key]))
            }
            components.queryItems = queryParams
        }

        return components.url
    }

    var plainRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
//        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = requestMethod.rawValue

        if let token = token {
            request.addValue(token, forHTTPHeaderField: "Token")
        }

        let encoder = JSONEncoder()

        if let bodyParams = bodyParams, let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams) {
            request.httpBody = jsonData
        }
        return request
    }

    var multipartRequest: URLRequest? {
        guard let url = self.url else { return nil }

        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue

        if let token = token {
            request.addValue(token, forHTTPHeaderField: "Token")
        }

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

         var body = Data()

        if let bodyParams = bodyParams {
            for param in bodyParams {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(param.key)\"\r\n\r\n")
                body.append("\(param.value)\r\n")
            }
        }

        if let binaryParams = binaryParams {

            for binary in binaryParams {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(binary.key)\"; filename=\"profileImage.jpg\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(binary.value)
                body.append("\r\n")
            }
        }

        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        return request
    }

    // MARK: making request section
    static func makeGetUsersRequest(page: Int, count: Int) -> TestTaskRequest {
        let params: [String: String] = [
            "page": "\(page)",
            "count": "\(count)"
        ]
        return TestTaskRequest(path: "/users", requestMethod: .get, queryParams: params)
    }

    static func makeGetPositionsReuest() -> TestTaskRequest {
        return TestTaskRequest(path: "/positions", requestMethod: .get)
    }

    static func getTokenRequest() -> TestTaskRequest {
         TestTaskRequest(path: "/token", requestMethod: .post)
    }

    static func createNewUser( bodyParams: [String: String], binaryParams: [String: Data], token: String) -> TestTaskRequest {
        TestTaskRequest(path: "/users", requestMethod: .post, token: token, bodyParams: bodyParams, binaryParams: binaryParams)
    }
}

enum TestTaskRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

extension Data {
    mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
