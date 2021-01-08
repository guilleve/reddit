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

/**
 This class manages the post according to the ListingRepository protocol
 */
class PostRepository: ListingRepository {
    
    private var pageSize: Int
    private var posts = [PostState]()
    private var listingType: RedditAPI.ListingType
    private var isLoadingMore = false
    private var service: RedditAPIService
    private var storage: PostStateStorage
    /**
    Post id of last service call used to do the pagination, gotten from ListingResponse.data.after
     */
    private var after: String?
    
    /**
     Initialization of repository
     - parameter service: concrete instance of RedditAPIService.
     - parameter storage: concrete instance of PostStateStorage.
     - parameter listingType: type of post to be retrieved..
     - parameter pageSize: page size used to retrieve post from server.
     */
    init(service: RedditAPIService,
         storage: PostStateStorage,
         listingType: RedditAPI.ListingType = .top,
         pageSize: Int = 10) {
        
        self.service = service
        self.storage = storage
        self.listingType = listingType
        self.pageSize = pageSize
    }
    
    /**
     Return the number of post.
     */
    var postCount: Int {
        posts.count
    }
    
    /**
     Return a post by index.
     */
    func postAtIndex(_ index: Int) -> PostState {
        return posts[index]
    }
    
    /**
    Retrieve from the service the *count* number of post, and filter the ones that have been dismissed using the local storage.
     This method always remove all the existing posts before doing the service call.
     */
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
                    onSuccess()
                case .failure(let error):
                    onFail(error)
                }
            })
    }
    
    /**
    Retrieve from the service the *count* number of post, and filter the ones that have been dismissed using the local storage.
     For the pagination, it uses the *after* property result of calling before getAll(..) method.
     This method append the result posts to existing list of post.
     */
    func loadMore(onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void) {
        if isLoadingMore {
            return
        }
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
    
    /**
     Mark a post as read in the local storage.
     */
    func markAsRead(post: PostState) {
        storage.markAsRead(post: post)
        if let index = posts.firstIndex(of: post) {
            posts[index].read = true
        }
    }
    
    /**
     Mark a post as dismissed in the local storage and return the position, if any, else, return nil.
     */
    func dismiss(post: PostState) -> Int? {
        storage.dismiss(post: post)
        if let index = posts.firstIndex(of: post) {
            posts.remove(at: index)
            return index
        }
        return nil
    }
    
    /**
     Mark all posts as dismissed in the local storage.
     */
    func dimissAllPost() {
        storage.dismissAll(posts: posts)
        posts.removeAll()
    }
    
    /**
    Reset all post states by clearing the local storage.
     */
    func resetPosts() {
        storage.clear()
    }
}
