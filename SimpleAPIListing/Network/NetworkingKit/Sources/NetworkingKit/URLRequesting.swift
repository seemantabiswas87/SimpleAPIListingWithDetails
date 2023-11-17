//
//  URLRequesting.swift
//  NetworkingKit
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

/// Provides functions for requesting and processing URL data
public protocol URLRequesting {
    /// Makes a URL Request
    func makeURLRequest() throws -> URLRequest
}

public extension URLRequesting {
    /// Request endpoint with a Decodable response
    func request<T: Decodable>(type: T.Type) async -> Result<T, Error>  {
        do {
            return await NetworkRequest().request(urlRequest: try makeURLRequest())
        } catch {
            return .failure(error)
        }
    }
}


