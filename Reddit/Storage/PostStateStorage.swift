//
//  PostStateStorage.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation

/**
 This class manages the post state using a concrete instance of *LocalStorage*. It keeps a list of read and dismissed posts in memory acting as cache
 in order to avoid the access to the local storage every time a value is required.
 */
class PostStateStorage {
    
    private(set) var readPostIds = [String]()
    private(set) var dismissedPostIds = [String]()
    private let storage: LocalStorage

    init(storage: LocalStorage) {
        self.storage = storage
        self.readPostIds = storage.getReadPostIds()
        self.dismissedPostIds = storage.getDismissedPostIds()
    }
    
    func markAsRead(post: PostState) {
        readPostIds.append(post.id)
        storage.save(dismissedPostIds: readPostIds)
    }

    func dismiss(post: PostState) {
        dismissedPostIds.append(post.id)
        storage.save(dismissedPostIds: dismissedPostIds)
    }
    
    func dismissAll(posts: [PostState]) {
        dismissedPostIds.append(contentsOf: posts.map({$0.id}))
        storage.save(dismissedPostIds: dismissedPostIds)
    }
    
    func clear() {
        dismissedPostIds.removeAll()
        readPostIds.removeAll()
        storage.clear()
    }

}
