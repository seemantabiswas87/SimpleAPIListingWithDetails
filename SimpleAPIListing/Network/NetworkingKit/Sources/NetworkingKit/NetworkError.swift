//
//  Errors.swift
//  NetworkingKit
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

public enum NetworkError: LocalizedError {
    case badUrl(url: URL?)
    case noData
    case invalidJson(decodingType: String, error: Error)
    case invalidStatus(code: Int, url: URL?)
    case unknownError

    public var errorDescription: String? {
        switch self {
        case .badUrl(url: let url):
            return "Network failed accessing url: \(String(describing: url))"
        case .noData:
            return "No data contained in response"
        case .invalidJson(decodingType: let decodingType, error: let error):
            return "Invalid JSON for type: \(decodingType), with error: \(error)"
        case .invalidStatus(code: let code, url: let url):
            return "Invalid status code \(code) received from: \(String(describing: url))"
        case .unknownError:
            return "Could not get the error"
        }
    }
}
