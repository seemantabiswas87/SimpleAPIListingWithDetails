//
//  MovieDetailsViewModelTests.swift
//  SimpleAPIListingTests
//
//  Created by Seemanta on 2023-11-17.
//

import XCTest
@testable import SimpleAPIListing


final class MovieDetailsViewModelTests: XCTestCase {

    static let mockMovieDetailsResponse = "{\"vote_average\": 8.0,\n \"release_date\": \"1st January 2023\",\n \"runtime\": 139,\n \"id\": 123,\n \"title\": \"Title\",\n  \"overview\": \"This is description\",\n  \"backdrop_path\": \"http://localhost/test\"}"
    override class func setUp() {
        ReachabilityMonitor.shared.startMonitoring()
    }
    override class func tearDown() {
        ReachabilityMonitor.shared.stopMonitoring()
    }

    func testFetchDetailsSuccess() async {
        let apiDataProvider = MockAPIDataProvider(failable: false, mockResponse: MovieDetailsViewModelTests.mockMovieDetailsResponse)
        let dataProvider = DetailDataProvider(apiDataProvider: apiDataProvider, storageDataProvider: mockDetailStore(urlRequest: .test))
        let viewModel = MovieDetailViewModel(dataProvider: dataProvider)
        wait(viewModel.movieDetails != nil)
        XCTAssertEqual(viewModel.movieDetails?.id, 123)
        XCTAssertNil(viewModel.errorText)
    }

    func testFetchDetailsFailed() async {
        let apiDataProvider = MockAPIDataProvider(failable: true)
        let storage = mockDetailStore(urlRequest: .test)
        let dataProvider = DetailDataProvider(apiDataProvider: apiDataProvider, storageDataProvider: storage)
        await storage.cache.removeAllValues()
        let viewModel = MovieDetailViewModel(dataProvider: dataProvider)
        wait(viewModel.errorText != nil)
        XCTAssertNil(viewModel.movieDetails)
        XCTAssertNotNil(viewModel.errorText)
    }
}

extension XCTestCase {
    func wait(
        _ condition: @escaping @autoclosure () -> (Bool),
        timeout: TimeInterval = 10)
    {
        wait(for: [XCTNSPredicateExpectation(
            predicate: NSPredicate(block: { _, _ in condition() }), object: nil
        )], timeout: timeout)
    }
}
