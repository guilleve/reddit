//
//  RedditService.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

protocol RedditAPIService {
    
    func listing(listingType type: RedditAPI.ListingType,
                 count pageSize: Int?,
                 before beforePostId: String?,
                 after afterPostId: String?,
                 completion: @escaping (Result<ListingResponse, ServiceError>) -> Void)
}

enum RedditAPIParamKey {
    static let before = "before"
    static let after  = "after"
    static let limit  = "limit"
}

class RedditService: RedditAPIService {
    
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
        
    func listing(listingType type: RedditAPI.ListingType,
                 count pageSize: Int?,
                 before beforePostId: String? = nil,
                 after afterPostId: String? = nil,
                 completion: @escaping (Result<ListingResponse, ServiceError>) -> Void) {
        
        var params: [String: String] = [:]
        if let after = afterPostId {
            params[RedditAPIParamKey.after] = after
        }
        if let before = beforePostId {
            params[RedditAPIParamKey.before] = before
        }
        if let limit = pageSize {
            params[RedditAPIParamKey.limit] = "\(limit)"
        }
        
        let url = RedditAPI.listing(type).endpointUrl
        let resource = Resource<ListingResponse>(get: URL(string: url)!, params: params)
        urlSession.load(resource) { result in
            completion(result)
        }
    }
}
