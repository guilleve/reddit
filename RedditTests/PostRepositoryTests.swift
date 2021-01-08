//
//  PostRepositoryTests.swift
//  RedditTests
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation
import XCTest
@testable import Reddit

class MockService: RedditAPIService {
    func listing(listingType type: RedditAPI.ListingType, count pageSize: Int?, before beforePostId: String?, after afterPostId: String?, completion: @escaping (Result<ListingResponse, ServiceError>) -> Void) {
        
        let post1 = Post(id: "post1",
                        title: "title",
                        author: "author",
                        createdAt: Date(),
                        thumbnailUrl: "thumbnailUrl",
                        numOfcomments: 1,
                        imageUrl: "imageUrl")
        let post2 = Post(id: "post2",
                        title: "title",
                        author: "author",
                        createdAt: Date(),
                        thumbnailUrl: "thumbnailUrl",
                        numOfcomments: 1,
                        imageUrl: "imageUrl")
        let post3 = Post(id: "post3",
                        title: "title",
                        author: "author",
                        createdAt: Date(),
                        thumbnailUrl: "thumbnailUrl",
                        numOfcomments: 1,
                        imageUrl: "imageUrl")
        let postItems = [PostItem(kind: "", data: post1),
                         PostItem(kind: "", data: post2),
                         PostItem(kind: "", data: post3)]
        let childrens = Childrens(modhash: "", after: "", before: "", children: postItems)
        let response = ListingResponse(kind: "kind", data: childrens)
        completion(.success(response))
    }
}

class MockStorage: LocalStorage {
    
    var readPostIds = [String]()
    var dimissedPostIds = [String]()

    func save(readPostIds: [String]) {
        self.readPostIds = readPostIds
    }
    
    func getReadPostIds() -> [String] {
        return readPostIds
    }
    
    func save(dismissedPostIds: [String]) {
        self.dimissedPostIds = dismissedPostIds
    }
    
    func getDismissedPostIds() -> [String] {
        return dimissedPostIds
    }
    
    func clear() {
        readPostIds.removeAll()
        dimissedPostIds.removeAll()
    }
}

class PostRepositoryTests: XCTestCase {
    
    let repository = PostRepository(service: MockService(),
                                    storage: PostStateStorage(storage: UserDefaultsStorage()),
                                    pageSize: 3)
    
    override func tearDown() {
        repository.resetPosts()
    }
    
    func testGetAll() {
        repository.getAll(
            onSuccess: {
                XCTAssertEqual(self.repository.postCount, 3)
                XCTAssertEqual(self.repository.postAtIndex(2).id, "post3")
            }, onFail: { error in
                XCTFail("test case should not fail")
            })
    }
    
    func testLoadMore() {
        repository.getAll(onSuccess: {}, onFail: { _ in})
        repository.loadMore(
            onSuccess: { [weak self] count in
                guard let self = self else {return}
                XCTAssertEqual(self.repository.postCount, 6)
                XCTAssertEqual(self.repository.postAtIndex(3).id, "post1")
            }, onFail: { error in
                XCTFail("test case should not fail")
            })
    }
    
    func testGetallFilterDismissed() {
        repository.getAll(
            onSuccess: {
                XCTAssertEqual(self.repository.postCount, 3)
                _ = self.repository.dismiss(post: self.repository.postAtIndex(0))
                XCTAssertEqual(self.repository.postCount, 2)
            }, onFail: { error in
                XCTFail("test case should not fail")
            })
    }
}
