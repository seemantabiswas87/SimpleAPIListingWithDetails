//
//  MockStorageDataProvider.swift
//  SimpleAPIListingTests
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation
import NetworkingKit
@testable import SimpleAPIListing

class MockStorageDataProvider: StorageDataProvider<MockCodableModel> {

    var spy = MockStorageDataProvider.Spy()

    private let failable: Bool
    init(failable: Bool, urlRequest: MovieURLRequest) {
        self.failable = failable
        super.init(urlRequest: urlRequest)
    }

    override func saveDataToCache(data: MockCodableModel?) async {
        spy.dataSaveToCache = true
    }

    override func loadDataFromCache() async -> MockCodableModel? {
        if failable {
          return nil
        } else {
            spy.dataLoadedFromCache = true
            return MockCodableModel.makeItem()
        }
    }
}

extension MockStorageDataProvider {
    class Spy {
        public var dataSaveToCache: Bool = false
        public var dataLoadedFromCache: Bool = false

    }
}


