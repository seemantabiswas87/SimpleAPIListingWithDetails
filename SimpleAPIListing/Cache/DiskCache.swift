//
//  DiskCache.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

fileprivate protocol NSCacheType: Cache {
    var cache: NSCache<NSString, DataEntry<T>> { get }
    var keysTracker: KeysTracker<T> { get }
}

extension NSCacheType {

    func removeValue(forKey key: String) {
        keysTracker.keys.remove(key)
        cache.removeObject(forKey: key as NSString)
    }

    func removeAllValues() {
        keysTracker.keys.removeAll()
        cache.removeAllObjects()
    }

    func setValue(_ value: T, forKey key: String) {
        let expiredTimestamp = Date().addingTimeInterval(expirationInterval)
        let cacheEntry = DataEntry(key: key, value: value, expireTimestamp: expiredTimestamp)
        insert(cacheEntry)

    }

    func value(forKey key: String) -> T? {
        entry(forKey: key)?.value
    }

    func entry(forKey key: String) -> DataEntry<T>? {
        guard let entry = cache.object(forKey: key as NSString) else {
            return nil
        }

        guard !entry.isCacheExpired(after: Date()) else {
            removeValue(forKey: key)
            return nil
        }

        return entry
    }

    func insert(_ entry: DataEntry<T>) {
        keysTracker.keys.insert(entry.key)
        cache.setObject(entry, forKey: entry.key as NSString)
    }

}

actor DiskCache<T: Codable>: NSCacheType {

    fileprivate let cache: NSCache<NSString, DataEntry<T>> = .init()
    fileprivate let keysTracker: KeysTracker<T> = .init()

    let filename: String
    let expirationInterval: TimeInterval

    init(filename: String, expirationInterval: TimeInterval) {
        self.filename = filename
        self.expirationInterval = expirationInterval
    }

    private var saveLocationURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("\(filename).cache")
    }

    func saveToDisk() throws {
        let entries = keysTracker.keys.compactMap(entry)
        let data = try JSONEncoder().encode(entries)
        try data.write(to: saveLocationURL)
    }

    func loadFromDisk() throws {
        let data = try Data(contentsOf: saveLocationURL)
        let entries = try JSONDecoder().decode([DataEntry<T>].self, from: data)
        entries.forEach { insert($0) }
    }
}

