//
//  URLRequest.swift
//  NetworkingKit
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

public extension URLRequest {
    class Builder {
        private let baseURL: String
        private var path: String?
        private var method: HTTPMethod = .get
        private var parameters: [String: String] = [:]
        private var headers: [String: String]?


        public init(withBaseURL baseURL: String) {
            self.baseURL = baseURL
        }

        public func path(_ path: String) -> Self {
            self.path = path
            return self
        }

        public func method(_ method: HTTPMethod) -> Self {
            self.method = method
            return self
        }

        public func parameters(_ parameters: [String: String]) -> Self {
            self.parameters = parameters
            return self
        }

        public func headers(_ headers: [String: String]) -> Self {
            self.headers = headers
            return self
        }

        public func build() throws -> URLRequest {
            guard
                let path = path,
                let url = URL(string: baseURL + path) else {
                throw BuilderError.pathNotSet
            }

            let queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }


            var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if !queryItems.isEmpty {
                urlComponent?.queryItems = queryItems
            }

            guard let url = urlComponent?.url else {
                throw URLError(.badURL)
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            headers?.forEach { key, value in
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            return urlRequest
        }
    }
}

extension URLRequest.Builder {
    public enum BuilderError: Error {
        case badURL
        case pathNotSet
    }
}
