//
//  NetworkRequest.swift
//  NetworkingKit
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

/// Provides methods for requesting HTTP data
struct  NetworkRequest {
    /// Performs an HTTP network request for a return type that supports Decodable
    ///
    /// - Parameters:
    ///   - urlRequest: The URLRequest of the resource
    ///
    func request<T: Decodable>(urlRequest: URLRequest) async -> Result<T, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let result = try ResponseHandler<T>().getResult(from: data, response: response)
            return .success(result)
        } catch {
            return .failure(error)
        }

    }
}
