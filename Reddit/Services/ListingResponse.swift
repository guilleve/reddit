//
//  ListingResponse.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

struct ListingResponse: Codable {
    var kind: String
    var data: Childrens
}

struct Childrens: Codable {
    var modhash: String
    var after : String?
    var before : String?
    var children: [PostItem]
}

struct PostItem: Codable {
    var kind: String
    let data: Post
}
