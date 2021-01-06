//
//  LocalStorage.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/6/21.
//

import Foundation

protocol LocalStorage {
    func save(readPostIds: [String])
    func getReadPostIds() -> [String]
    func save(dismissedPostIds: [String])
    func getDismissedPostIds() -> [String]
}

class UserDefaultsStorage: LocalStorage {
    
    enum StateKey {
        static let readPosts = "readPosts"
        static let dismissedPosts = "dismissedPosts"
    }
    
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save(readPostIds: [String]) {
        setArray(readPostIds, key: StateKey.readPosts)
    }
    
    func getReadPostIds() -> [String] {
        return getArray(key: StateKey.readPosts, defaultValue: [])
    }
    
    func save(dismissedPostIds: [String]) {
        setArray(dismissedPostIds, key: StateKey.dismissedPosts)
    }
    
    func getDismissedPostIds() -> [String] {
        return getArray(key: StateKey.dismissedPosts, defaultValue: [])
    }
    
}

extension UserDefaultsStorage {
    
    private func getArray<T>(key: String, defaultValue: Array<T>) -> Array<T> {
        return userDefaults.object(forKey: key) as? Array<T> ?? defaultValue
    }

    private func setArray<T>(_ newValue: Array<T>?, key: String) {
        userDefaults.set(newValue, forKey: key)
    }
    
}
