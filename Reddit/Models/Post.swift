//
//  Post.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

struct Post {
    var id: String
    var title: String
    var author: String
    var createdAt: Date
    var thumbnailUrl: String?
    var numOfcomments: Int
    var imageUrl: String?
}

extension Post: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "name"
        case title
        case author
        case thumbnailUrl = "thumbnail"
        case numOfcomments = "num_comments"
        case createdAt = "created_utc"
        case imageUrl = "url"
    }
}
