//
//  UserDefaultsStorage.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation

class UserDefaultsStorage: LocalStorage {
    
    enum PostStateKeys {
        static let readPosts = "readPosts"
        static let dismissedPosts = "dismissedPosts"
    }
    
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save(readPostIds: [String]) {
        userDefaults.setArray(readPostIds, key: PostStateKeys.readPosts)
    }
    
    func getReadPostIds() -> [String] {
        return userDefaults.getArray(key: PostStateKeys.readPosts, defaultValue: [])
    }
    
    func save(dismissedPostIds: [String]) {
        userDefaults.setArray(dismissedPostIds, key: PostStateKeys.dismissedPosts)
    }
    
    func getDismissedPostIds() -> [String] {
        return userDefaults.getArray(key: PostStateKeys.dismissedPosts, defaultValue: [])
    }
    
    func clear() {
        userDefaults.setArray([], key: PostStateKeys.dismissedPosts)
        userDefaults.setArray([], key: PostStateKeys.readPosts)
    }
}
