//
//  NetworkResponse.swift
//  NetworkingKit
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

/// Processes the results of a URLSessionResponse
struct ResponseHandler<T: Decodable> {
    /// Gets the result from a response
    /// - Returns: The value of the response
    func getResult(from data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.badUrl(url: response.url)
        }
        switch httpResponse.statusCode {
        case 200...299:
            return try handleSuccess(from: data)
        case 400...451:
            throw NetworkError.noData
        default:
            throw NetworkError.invalidStatus(code: httpResponse.statusCode, url: response.url)
        }
    }
}

private extension ResponseHandler {
    func handleSuccess(from data: Data) throws -> T {
        guard !data.isEmpty else { throw NetworkError.noData }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.invalidJson(decodingType: String(describing: T.self), error: error)
        }
    }

}
