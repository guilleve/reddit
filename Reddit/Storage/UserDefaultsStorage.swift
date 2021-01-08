//
//  UserDefaultsStorage.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation

//LocalStorage: The post state is saved in the local storage by using UserDefaults (just saving ids)
//due to time limitations. This method is not intended for saving big amount of data that is read
//frecuently because each time it reads/writes the whole file, so it isn't efficient.
//The ideal would be to use another type of storage like CoreData, realm, etc for saving the post states,
//and even better to save the post objets to support offline mode.

/**
 Concrete implementation of LocalStorage interface.
 It uses UserDefaults to get/save post status id.
 */
class UserDefaultsStorage: LocalStorage {
    
    enum PostStateKeys {
        static let readPosts = "readPosts"
        static let dismissedPosts = "dismissedPosts"
    }
    
    private var userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /**
     Save an array of read post ids.
     */
    func save(readPostIds: [String]) {
        userDefaults.setArray(readPostIds, key: PostStateKeys.readPosts)
    }
    
    /**
     Retrieve an array of read post ids.
     */
    func getReadPostIds() -> [String] {
        return userDefaults.getArray(key: PostStateKeys.readPosts, defaultValue: [])
    }
    
    /**
     Save an array of dismissed post ids.
     */
    func save(dismissedPostIds: [String]) {
        userDefaults.setArray(dismissedPostIds, key: PostStateKeys.dismissedPosts)
    }
    
    /**
     Retrieve an array of dismissed post ids.
     */
    func getDismissedPostIds() -> [String] {
        return userDefaults.getArray(key: PostStateKeys.dismissedPosts, defaultValue: [])
    }
    
    /**
     Clear the list of read and dismissed post ids.
     */
    func clear() {
        userDefaults.setArray([], key: PostStateKeys.dismissedPosts)
        userDefaults.setArray([], key: PostStateKeys.readPosts)
    }
}
