//
//  MovieURLRequest.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation
import NetworkingKit

enum MovieURLRequest: URLRequesting {
    case listing
    case details(id: Int)
    case test

    var rawValue: String {
        switch self {
        case .details(let id): return "MovieDetails-\(id)"
        case .listing: return "MovieListing"
        case .test: return "Test"
        }
    }

    func makeURLRequest() throws -> URLRequest {
        switch self {
        case .listing:
            return try URLRequest.Builder(withBaseURL: "")
                .path("/3/movie/top_rated")
                .method(.get)
                .headers(header)
                .build()
        case .details(let id):
            return try URLRequest.Builder(withBaseURL: "https://api.themoviedb.org")
                .path("/3/movie/\(id)")
                .method(.get)
                .headers(header)
                .build()
        case .test:
            return try URLRequest.Builder(withBaseURL: "http://localhost.com")
                .path("/path")
                .method(.get)
                .build()
        }
    }
}

 extension MovieURLRequest {
    var header: [String: String] {
        // Access Token to use in Bearer header
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyOGZiMmU3NzRkODlkYjkxOTdkMmRkMTViY2MzODFkYyIsInN1YiI6IjY0ZWY3ZWE0ZGJiYjQyMDBlMTYxZmM3MyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.lvESP6efyK9MMBVAlsvceLoYySuS_xCInwrT-3dEpRo"
        return [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
}

