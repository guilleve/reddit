//
//  PostState.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

struct PostState: Equatable {
    
    var post: Post
    var read: Bool = false
    var dismiss: Bool = false
    
    static func == (lhs: PostState, rhs: PostState) -> Bool {
        return lhs.post.id == rhs.post.id
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
        return DateFormatter().string(from: post.createdAt)
    }
    
    var imageUrl: String? {
        return post.imageUrl
    }
    
    var thumbnailUrl: String? {
        return post.thumbnailUrl
    }
}
