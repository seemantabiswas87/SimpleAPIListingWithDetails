//
//  MockAPIDataProvider.swift
//  SimpleAPIListingTests
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation
import NetworkingKit
@testable import SimpleAPIListing

struct MockAPIDataProvider: APIDataProviding {
    var request = MovieURLRequest.test
    let response: String?

    private let failable: Bool
    init(failable: Bool, mockResponse: String? = nil) {
        self.failable = failable
        self.response = mockResponse
    }

    func getData<T:Codable>(type: T.Type) async throws -> Result<T, Error>? {

        if failable {
            return .failure(NetworkError.noData)
        } else {
            let string = self.response ?? "{\"title\": \"Title\",\n  \"subtitle\": \"This is Subtitle\",\n  \"imageUrl\": \"http://localhost/test\"}"
            let response = Data(string.utf8)
            do {
                let responseModel = try JSONDecoder().decode(T.self, from: response)
                return .success(responseModel)
            } catch(let error) {
                return .failure(NetworkError.invalidJson(decodingType: String(describing: T.self), error: error))
            }
        }

    }
}
