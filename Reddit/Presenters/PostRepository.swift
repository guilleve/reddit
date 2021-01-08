//
//  PostRepository.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/6/21.
//

import Foundation

protocol ListingRepository: class {
    func getAll(onSuccess: @escaping () -> Void, onFail: @escaping (ServiceError) -> Void)
    func loadMore(onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void)
    func markAsRead(post: PostState)
    func dismiss(post: PostState) -> Int?
    func dimissAllPost()
    func postAtIndex(_ index: Int) -> PostState
    var postCount: Int {get}
    func resetPosts()
}

class PostRepository: ListingRepository {
    
    private var pageSize: Int
    private var posts = [PostState]()
    private var listingType: RedditAPI.ListingType
    private var isLoadingMore = false
    private var after: String?
    private var service: RedditAPIService
    private var storage: PostStateStorage
    
    init(service: RedditAPIService,
         storage: PostStateStorage,
         listingType: RedditAPI.ListingType = .top,
         pageSize: Int = 10) {
        
        self.service = service
        self.storage = storage
        self.listingType = listingType
        self.pageSize = pageSize
    }
    
    var postCount: Int {
        posts.count
    }
    
    func postAtIndex(_ index: Int) -> PostState {
        return posts[index]
    }
    
    func getAll(onSuccess: @escaping () -> Void, onFail: @escaping (ServiceError) -> Void) {
        posts.removeAll()
        service.listing(
            listingType: listingType,
            count: pageSize,
            before: nil,
            after: nil,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.after = response.data.after
                    self.posts = response.data.children.map {
                        PostState(post: $0.data,
                                  read: self.storage.readPostIds.contains($0.data.id),
                                  dismiss: self.storage.dismissedPostIds.contains($0.data.id))
                    }.filter({!$0.dismiss})
                    print("success: \(self.posts)")
                    onSuccess()
                case .failure(let error):
                    print("error: \(error)")
                }
            })
    }
    
    func loadMore(onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void) {
        isLoadingMore = true
        service.listing(
            listingType: listingType,
            count: pageSize,
            before: nil,
            after: after,
            completion: { [weak self] result in
                guard let self = self else { return }
                self.isLoadingMore = false
                switch result {
                case .success(let response):
                    self.after = response.data.after
                    let newPosts = response.data.children.map {
                        PostState(post: $0.data,
                                  read: self.storage.readPostIds.contains($0.data.id),
                                  dismiss: self.storage.dismissedPostIds.contains($0.data.id))
                    }.filter({!$0.dismiss})
                    self.posts.append(contentsOf: newPosts)
                    onSuccess(newPosts.count)
                case .failure(let error):
                    self.isLoadingMore = false
                    onFail(error)
                }
            })
    }
    
    func markAsRead(post: PostState) {
        storage.markAsRead(post: post)
        if let index = posts.firstIndex(of: post) {
            posts[index].read = true
        }
    }
    
    func dismiss(post: PostState) -> Int? {
        storage.dismiss(post: post)
        if let index = posts.firstIndex(of: post) {
            posts.remove(at: index)
            return index
        }
        return nil
    }
    
    func dimissAllPost() {
        storage.dismissAll(posts: posts)
        posts.removeAll()
    }
    
    func resetPosts() {
        storage.clear()
    }
}
