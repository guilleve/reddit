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
}
