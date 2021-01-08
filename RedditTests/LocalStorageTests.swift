//
//  LocalStorageTests.swift
//  RedditTests
//
//  Created by Guillermo Vergara on 1/8/21.
//

import Foundation
import XCTest
@testable import Reddit

class LocalStorageTests: XCTestCase {
    
    let storage = UserDefaultsStorage(userDefaults: UserDefaults.init(suiteName: "LocalStorageTests")!)
    
    func testSaveGetReadPost() {
        storage.save(readPostIds: ["id1", "id2"])
        let readPosts = storage.getReadPostIds()
        XCTAssertEqual(readPosts.count, 2)
        XCTAssertEqual(readPosts[0], "id1")
    }
    
    func testSaveGetDimissedPost() {
        storage.save(dismissedPostIds: ["id1", "id2", "id3"])
        let readPosts = storage.getDismissedPostIds()
        XCTAssertEqual(readPosts.count, 3)
        XCTAssertEqual(readPosts[2], "id3")
    }
}
