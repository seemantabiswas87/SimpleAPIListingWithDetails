//
//  MockTestableClasses.swift
//  SimpleAPIListingTests
//
//  Created by Seemanta on 2023-11-17.
//
@testable import SimpleAPIListing

class mockDetailStore: StorageDataProvider<MovieDetails>{}
class MockDataProvider: MovieDataProvider<MockCodableModel> {}
