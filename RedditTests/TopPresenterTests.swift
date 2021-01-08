//
//  RedditTests.swift
//  RedditTests
//
//  Created by Guillermo Vergara on 1/4/21.
//

import XCTest
@testable import Reddit

class MockRepository: ListingRepository {

    var posts = [PostState]()
    var success = true
    func getAll(onSuccess: @escaping () -> Void, onFail: @escaping (ServiceError) -> Void) {
        if success {
            let post = Post(id: "post1",
                            title: "title",
                            author: "author",
                            createdAt: Date(),
                            thumbnailUrl: "thumbnailUrl",
                            numOfcomments: 1,
                            imageUrl: "imageUrl")
            let postState = PostState(post: post, read: false, dismiss: false)
            self.posts = [postState]
            onSuccess()
        } else {
            onFail(.noDataError)
        }
    }
    
    func loadMore(onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void) {
        if success {
            let post = Post(id: "post2",
                            title: "title",
                            author: "author",
                            createdAt: Date(),
                            thumbnailUrl: "thumbnailUrl",
                            numOfcomments: 1,
                            imageUrl: "imageUrl")
            let postState = PostState(post: post, read: false, dismiss: false)
            self.posts.append(contentsOf: [postState])
            onSuccess(1)
        } else {
            onFail(.noDataError)
        }
    }
    
    func markAsRead(post: PostState) {
    }
    
    func dismiss(post: PostState) -> Int? {
        return 0
    }
    
    func dimissAllPost() {
    }
    
    func postAtIndex(_ index: Int) -> PostState {
        self.posts[index]
    }
    
    var postCount: Int {self.posts.count}
    
    func resetPosts() {
        
    }
}

class TopPostPresenterTests: XCTestCase {

    var presenter: TopPostPresenter!
    var repository = MockRepository()
    
    override func setUp() {
        presenter = TopPostPresenter(repository: repository)
    }

    func testGetAllPostSuccess() {
        repository.success = true
        presenter.getAllPost(onSuccess: {[weak self] in
            XCTAssertEqual(self?.presenter.postCount, 1)
            XCTAssertEqual(self?.presenter.postAtIndex(0).id, "post1")
        }, onFail: {_ in
            XCTFail("test case should not fail")
        })
    }
    
    func testGetAllPostFail() {
        repository.success = false
        presenter.getAllPost(onSuccess: {
            XCTFail("test case should fail")
        }, onFail: {[weak self] _ in
            XCTAssertEqual(self?.presenter.postCount, 0)
        })
    }
    
    func testLoadMoreSuccess() {
        repository.success = true
        presenter.getAllPost(onSuccess: {}, onFail: {_ in})
        presenter.loadMore(onSuccess: {[weak self] count in
            XCTAssertEqual(count, 1)
            XCTAssertEqual(self?.presenter.postCount, 2)
        }, onFail: {_ in
            XCTFail("test case should not fail")
        })
    }
    
    func testLoadMoreFail() {
        repository.success = true
        presenter.getAllPost(onSuccess: {}, onFail: {_ in})
        repository.success = false
        presenter.loadMore(onSuccess: { count in
            XCTFail("test case should fail")
        }, onFail: { [weak self] _ in
            XCTAssertEqual(self?.presenter.postCount, 1)
        })
    }
}
