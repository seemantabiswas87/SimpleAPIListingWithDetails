//
//  DataModel.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

protocol ImageProvider {
    var imagePath: String { get }
    func makeImageUrl(width: Int) -> URL?
}

extension ImageProvider {
    func makeImageUrl(width: Int = 200) -> URL? {
        URL(string: "\(imageHost)w\(String(describing: width))\(imagePath)")
    }
}

struct Listing: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
struct Movie: Codable, Identifiable, ImageProvider {
    let id: Int
    let title: String
    let description: String
    let imagePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "overview"
        case imagePath = "poster_path"
    }

    func makeImageUrl(width: Int = 200) -> URL? {
        URL(string: "\(imageHost)w\(String(describing: width))\(imagePath)")
    }
}

struct MovieDetails: Codable, ImageProvider {
    let id: Int
    let title: String
    let description: String
    let imagePath: String
    let releaseDate: String
    let runtime: Int
    let rating: CGFloat

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description = "overview"
        case imagePath = "backdrop_path"
        case releaseDate = "release_date"
        case runtime
        case rating = "vote_average"
    }
}


private let imageHost = "http://image.tmdb.org/t/p/"

