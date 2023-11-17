//
//  Cache.swift
//  SimpleAPIListing
//
//  Created by Seemanta on 2023-11-17.
//

import Foundation

protocol Cache: Actor {

    associatedtype T
    var expirationInterval: TimeInterval { get }

    func setValue(_ value: T, forKey key: String)
    func value(forKey key: String) -> T?

    func removeValue(forKey key: String)
    func removeAllValues()
}

final class DataEntry<T> {
    let key: String
    let value: T
    let expireTimestamp: Date

    init(key: String, value: T, expireTimestamp: Date) {
        self.key = key
        self.value = value
        self.expireTimestamp = expireTimestamp
    }

    func isCacheExpired(after date: Date = .now) -> Bool {
        date > expireTimestamp
    }
}

extension DataEntry: Codable where T: Codable {}


final class KeysTracker<V>: NSObject, NSCacheDelegate {
    var keys = Set<String>()
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        guard let entry = obj as? DataEntry<V> else {
            return
        }
        keys.remove(entry.key)
    }
}
