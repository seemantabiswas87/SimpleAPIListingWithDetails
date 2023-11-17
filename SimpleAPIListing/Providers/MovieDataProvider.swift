//
//  MovieDataProvider.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

enum LocalError: LocalizedError {
    case handledError(String)
    case unknownError
    case connectionError

    public var description: String {
        switch self {
        case .handledError(let description): return "Error in Network Kit - \(description)"
        case .connectionError: return "You are not connected to internet and your data is not cached. Please try when connection is available"
        case .unknownError: return "An unknown error has occured"
        }
    }
}

protocol DataProviding {
    associatedtype TModel: Codable
    var data: TModel? { get }
    func getData() async -> Result<TModel, LocalError>
}

class MovieDataProvider<T: Codable>: DataProviding {
    private(set) var data: T?

    private let apiDataProvider: APIDataProviding?
    private let storageDataProvider: StorageDataProvider<T>


    init(apiDataProvider: APIDataProviding,
         storageDataProvider: StorageDataProvider<T>) {
        self.apiDataProvider = apiDataProvider
        self.storageDataProvider = storageDataProvider
    }

    func getData() async -> Result<T, LocalError> {
        do {
            if ReachabilityMonitor.shared.isConnected {
                guard let result = try await apiDataProvider?.getData(type: T.self) else { return
                    .failure(.unknownError)
                }
                switch result {
                case .success(let value):
                    data = value
                    try await storageDataProvider.saveDataToCache(data: value)
                    return .success(value)
                case .failure(let error):
                    print("Network request failed with \(error)")
                    guard let dataFromCache = try await storageDataProvider.loadDataFromCache() else {
                        return .failure(.handledError(error.localizedDescription))
                    }
                    data = dataFromCache
                    return .success(dataFromCache)
                }
            } else {
                guard let dataFromCache = try await storageDataProvider.loadDataFromCache() else {
                    return .failure(.connectionError)
                }
                data = dataFromCache
                return .success(dataFromCache)
            }
        } catch(let error) {
            return .failure(.handledError(error.localizedDescription))
        }
    }
}


final class ListingDataProvider: MovieDataProvider<Listing> {}
final class DetailDataProvider: MovieDataProvider<MovieDetails> {}


final class ListingStore: StorageDataProvider<Listing>{}
final class DetailStore: StorageDataProvider<MovieDetails>{}
