//
//  TopPostsPresenter.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

class TopPostPresenter {

    var isLoading = false
    var repository: ListingRepository
    
    init(repository: ListingRepository) {
        self.repository = repository
    }
    
    func getAllPost(onSuccess: @escaping () -> Void, onFail: @escaping (ServiceError) -> Void) {
        isLoading = true
        repository.getAll(
            onSuccess: { [weak self] in
                self?.isLoading = false
                onSuccess()
            }, onFail: { [weak self] error in
                self?.isLoading = false
                onFail(error)
            })
    }
    
    func loadMore(onSuccess: @escaping (Int) -> Void, onFail: @escaping (ServiceError) -> Void) {
        isLoading = true
        repository.loadMore(
            onSuccess: { [weak self] newPostsCount in
                self?.isLoading = false
                onSuccess(newPostsCount)
            }, onFail: { [weak self] error in
                self?.isLoading = false
                onFail(error)
            })
    }
    
    func markAsRead(post: PostState) {
        repository.markAsRead(post: post)
    }
    
    func dismiss(post: PostState) -> Int? {
        repository.dismiss(post: post)
    }
    
    func dimissAllPost() {
        repository.dimissAllPost()
    }
    
    var postCount: Int {
        repository.postCount
    }
    
    func postAtIndex(_ index: Int) -> PostState {
        return repository.postAtIndex(index)
    }
}
