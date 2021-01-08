//
//  PostStateStorageTests.swift
//  RedditTests
//
//  Created by Guillermo Vergara on 1/8/21.
//

import Foundation
import XCTest
@testable import Reddit

class PostStateStorageTests: XCTestCase {
    
    let storage = PostStateStorage(
        storage: UserDefaultsStorage(
            userDefaults:
                UserDefaults(suiteName: "PostStateStorageTests")!
        )
    )
    
    override func tearDown() {
        storage.clear()
    }
    
    func testReadPost() {
        
        let post = Post(id: "postId1", title: "", author: "", createdAt: Date(), thumbnailUrl: "", numOfcomments: 0, imageUrl: "")
        storage.markAsRead(post: PostState(post: post, read: false, dismiss: false))
        
        XCTAssertEqual(storage.readPostIds.count, 1)
        XCTAssertTrue(storage.readPostIds.contains("postId1"))
    }
    
    func testDismissPost() {
        
        let post = Post(id: "postId", title: "", author: "", createdAt: Date(), thumbnailUrl: "", numOfcomments: 0, imageUrl: "")
        storage.dismiss(post: PostState(post: post, read: false, dismiss: false))
        
        XCTAssertEqual(storage.dismissedPostIds.count, 1)
        XCTAssertTrue(storage.dismissedPostIds.contains("postId"))
    }
    
    func testDismissAll() {
        
        let post1 = Post(id: "postId1", title: "", author: "", createdAt: Date(), thumbnailUrl: "", numOfcomments: 0, imageUrl: "")
        let post2 = Post(id: "postId2", title: "", author: "", createdAt: Date(), thumbnailUrl: "", numOfcomments: 0, imageUrl: "")
        storage.dismissAll(posts: [PostState(post: post1, read: false, dismiss: false),
                                   PostState(post: post2, read: false, dismiss: false)])
        
        XCTAssertEqual(storage.dismissedPostIds.count, 2)
        XCTAssertTrue(storage.dismissedPostIds.contains("postId1"))
        XCTAssertTrue(storage.dismissedPostIds.contains("postId2"))
    }
}
