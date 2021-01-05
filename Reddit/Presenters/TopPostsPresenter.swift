//
//  TopPostsPresenter.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

protocol PostPresenter: class {
    func getAllPost(onSuccess: @escaping ([PostState]) -> Void, onFail: @escaping (ServiceError) -> Void)
    func loadMore(onSuccess: @escaping ([PostState]) -> Void, onFail: @escaping (ServiceError) -> Void)
    func markPostAsRead(_ post: PostState)
    func dismissPost(_ post: PostState) -> Int?
    func dimissAllPost()
    var posts: [PostState] {get}
    var isLoading: Bool {get}
}

class TopPostPresenter: PostPresenter {
    
    let pageSize = 10
    var posts = [PostState]()
    var isLoading = false
    private var after: String?
    private var service: RedditAPIService
    private var readPosts = Set<String>()
    private var dismissedPosts = Set<String>()
    
    
    init(service: RedditAPIService) {
        self.service = service
    }
    
    func getAllPost(onSuccess: @escaping ([PostState]) -> Void, onFail: @escaping (ServiceError) -> Void) {
        posts.removeAll()
        isLoading = true
        service.listing(
            listingType: .top,
            count: pageSize,
            before: nil,
            after: nil,
            completion: { [unowned self] result in
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.after = response.data.after
                    self.posts = response.data.children.map{PostState(post: $0.data)}.filter({!$0.dismiss})
                    print("success: \(self.posts)")
                    onSuccess(self.posts)
                case .failure(let error):
                    print("error: \(error)")
                }
            })
    }
    
    func loadMore(onSuccess: @escaping ([PostState]) -> Void, onFail: @escaping (ServiceError) -> Void) {
        isLoading = true
        service.listing(
            listingType: .top,
            count: pageSize,
            before: nil,
            after: after,
            completion: { [unowned self] result in
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.after = response.data.after
                    let newPosts = response.data.children.map{PostState(post: $0.data)}.filter({!$0.dismiss})
                    self.posts.append(contentsOf: newPosts)
                    onSuccess(newPosts)
                    print("success: \(newPosts)")
                case .failure(let error):
                    print("error: \(error)")
                }
            })
    }
    
    func markPostAsRead(_ post: PostState) {
        readPosts.insert(post.post.id)
        if let index = posts.firstIndex(of: post) {
            posts[index].read = true
        }
    }
    
    func dismissPost(_ post: PostState) -> Int? {
        dismissedPosts.insert(post.post.id)
        if let index = posts.firstIndex(of: post) {
            posts.remove(at: index)
            return index
        }
        return nil
    }
    
    func dimissAllPost() {
        posts.forEach({dismissedPosts.insert($0.post.id)})
        posts.removeAll()
    }
}
