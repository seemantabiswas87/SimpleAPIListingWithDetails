//
//  StorageDataProvider.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

protocol StorageDataProviding {
    associatedtype TModel: Codable
    var cache: DiskCache<TModel> { get }
    var key: String { get }
    func saveDataToCache(data: TModel?) async throws
    func loadDataFromCache() async throws -> TModel?
}

public class StorageDataProvider<T: Codable>: StorageDataProviding {
    init (urlRequest: MovieURLRequest) {
        self.key = urlRequest.rawValue
        self.cache =  DiskCache<T>(filename: urlRequest.rawValue, expirationInterval: 5 * 60)
    }
    var cache: DiskCache<T>
    var key: String

    func loadDataFromCache() async throws -> T? {
        try? await cache.loadFromDisk()
        if let data = await cache.value(forKey: key) {
            print("Value received from cache")
            return data
        }
        print("Failed to load from cache")
        return nil
    }

    func saveDataToCache(data: T?) async throws{
        guard let data = data else { return }
        await cache.setValue(data, forKey: key)
        try? await cache.saveToDisk()
    }

}

