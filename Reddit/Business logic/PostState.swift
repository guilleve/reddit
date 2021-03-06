//
//  PostState.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

/**
 This class contains a post model instance and the read and dismiss status.
 It separates the model from the view.
 */
struct PostState: Equatable {
    
    private var post: Post
    var read: Bool = false
    var dismiss: Bool = false
    
    init(post: Post, read: Bool, dismiss: Bool) {
        self.post = post
        self.read = read
        self.dismiss = dismiss
    }
    
    static func == (lhs: PostState, rhs: PostState) -> Bool {
        return lhs.post.id == rhs.post.id
    }
    
    var id: String {
        return post.id
    }
    
    var userName: String {
        return post.author
    }
    
    var title: String {
        return post.title
    }
    
    var numberOfComments: String {
        return "\(post.numOfcomments) \(post.numOfcomments > 1 ? "Comments" : "Comment")"
    }
    
    var postedTime: String {
        return post.createdAt.timeAgo()
    }
    
    var imageUrl: String? {
        return post.imageUrl
    }
    
    var thumbnailUrl: String? {
        return post.thumbnailUrl
    }
}
