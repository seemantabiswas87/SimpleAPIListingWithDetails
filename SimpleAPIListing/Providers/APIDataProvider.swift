//
//  APIDataProvider.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation
import NetworkingKit

protocol APIDataProviding {
    var request: MovieURLRequest { get }
    func getData<T:Codable>(type: T.Type) async throws -> Result<T, Error>?
}

extension APIDataProviding {
    func getData<T: Codable>(type: T.Type) async throws -> Result<T, Error>? {
        await request.request(type: T.self)
    }
}

struct MovieAPIDataProvider: APIDataProviding {
    var request = MovieURLRequest.listing
}

struct MovieDetailsAPIDataProvider: APIDataProviding {
    let movieId: Int
    let request: MovieURLRequest
    init(movieId: Int) {
        self.movieId = movieId
        self.request = MovieURLRequest.details(id: movieId)
    }
}

