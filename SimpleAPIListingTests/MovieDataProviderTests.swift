//
//  MovieDataProviderTests.swift
//  SimpleAPIListingTests
//
//  Created by Seemanta on 2023-11-17.
//

import XCTest
@testable import SimpleAPIListing


final class MovieDataProviderTest: XCTestCase {

    override class func setUp() {
        ReachabilityMonitor.shared.startMonitoring()
    }
    override class func tearDown() {
        ReachabilityMonitor.shared.stopMonitoring()
    }

    func testOnLineModeSuccess() async throws {
        guard ReachabilityMonitor.shared.isConnected else {
            XCTAssert(true, "Cannot test this as scenario not supported")
            return
        }

        let apiDataProvider = MockAPIDataProvider(failable: false)
        let storageDataProvider = MockStorageDataProvider(failable: false, urlRequest: .test)


        let provider = MockDataProvider(apiDataProvider: apiDataProvider, storageDataProvider: storageDataProvider)
        XCTAssertFalse(storageDataProvider.spy.dataSaveToCache)
        XCTAssertFalse(storageDataProvider.spy.dataLoadedFromCache)
        let dataFromProvider = await  provider.getData()

        XCTAssertNotNil(provider.data)
        XCTAssertFalse(storageDataProvider.spy.dataLoadedFromCache)
        verifyData(result: dataFromProvider)
        XCTAssertTrue(storageDataProvider.spy.dataSaveToCache)

    }

    func testOnLineModeAPIFailCacheSuccess() async throws {
        guard ReachabilityMonitor.shared.isConnected else {
            XCTAssert(true, "Cannot test this as scenario not supported")
            return
        }

        let apiDataProvider = MockAPIDataProvider(failable: true)
        let storageDataProvider = MockStorageDataProvider(failable: false, urlRequest: .test)


        let provider = MockDataProvider(apiDataProvider: apiDataProvider, storageDataProvider: storageDataProvider)
        XCTAssertFalse(storageDataProvider.spy.dataSaveToCache)
        XCTAssertFalse(storageDataProvider.spy.dataLoadedFromCache)
        let _ = await  provider.getData()
        XCTAssertTrue(storageDataProvider.spy.dataLoadedFromCache)
        XCTAssertNotNil(provider.data)
    }

    func testOnLineModeFailure() async throws {
        guard ReachabilityMonitor.shared.isConnected else {
            XCTAssert(true, "Cannot test this as scenario not supported")
            return
        }

        let apiDataProvider = MockAPIDataProvider(failable: true)
        let storageDataProvider = MockStorageDataProvider(failable: true, urlRequest: .test)

        let provider = MockDataProvider(apiDataProvider: apiDataProvider, storageDataProvider: storageDataProvider)
        XCTAssertFalse(storageDataProvider.spy.dataSaveToCache)
        XCTAssertFalse(storageDataProvider.spy.dataLoadedFromCache)
        let _ = await  provider.getData()
        XCTAssertFalse(storageDataProvider.spy.dataLoadedFromCache)
        XCTAssertNil(provider.data)
    }

    private func verifyData(result: Result<MockCodableModel, LocalError>) {

        switch result {
        case .success(let data):
            XCTAssertEqual(data.title, "Title")
            XCTAssertEqual(data.subtitle, "This is Subtitle")
            XCTAssertEqual(data.imageUrl, "http://localhost/test")
        case .failure(let error):
            XCTFail(error.errorDescription ?? "")
        }

    }

}
