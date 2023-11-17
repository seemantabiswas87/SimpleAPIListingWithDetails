//
//  MockCodableModel.swift
//  SimpleAPIListingTests
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

public struct MockCodableModel: Codable {
    let title: String
    let subtitle: String
    let imageUrl: String

    static func makeItem() -> MockCodableModel {
        return .init(title: "title", subtitle: "subtitle", imageUrl: "localhost/image")
    }
}
