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
}

class PostRepository: ListingRepository {
    
    private var pageSize: Int
    private var posts = [PostState]()
    private var listingType: RedditAPIListingType
    private var isLoadingMore = false
    private var after: String?
    private var service: RedditAPIService
    private var storage: LocalStorage
    private(set) var readPostIds = [String]()
    private(set) var dismissedPostIds = [String]()
    
    init(service: RedditAPIService,
         storage: LocalStorage,
         listingType: RedditAPIListingType = .top,
         pageSize: Int = 10) {
        
        self.service = service
        self.storage = storage
        self.listingType = listingType
        self.pageSize = pageSize
        self.readPostIds = storage.getReadPostIds()
        self.dismissedPostIds = storage.getDismissedPostIds()
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
            completion: { [unowned self] result in
                switch result {
                case .success(let response):
                    self.after = response.data.after
                    self.posts = response.data.children.map {
                        PostState(post: $0.data,
                                  read: readPostIds.contains($0.data.id),
                                  dismiss: dismissedPostIds.contains($0.data.id))
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
            completion: { [unowned self] result in
                self.isLoadingMore = false
                switch result {
                case .success(let response):
                    self.after = response.data.after
                    let newPosts = response.data.children.map {
                        PostState(post: $0.data,
                                  read: readPostIds.contains($0.data.id),
                                  dismiss: dismissedPostIds.contains($0.data.id))
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
        readPostIds.append(post.id)
        storage.save(readPostIds: readPostIds)
        if let index = posts.firstIndex(of: post) {
            posts[index].read = true
        }
    }
    
    func dismiss(post: PostState) -> Int? {
        dismissedPostIds.append(post.id)
        storage.save(dismissedPostIds: dismissedPostIds)
        if let index = posts.firstIndex(of: post) {
            posts.remove(at: index)
            return index
        }
        return nil
    }
    
    func dimissAllPost() {
        posts.forEach({dismissedPostIds.append($0.id)})
        posts.removeAll()
        storage.save(dismissedPostIds: dismissedPostIds)
    }
}
