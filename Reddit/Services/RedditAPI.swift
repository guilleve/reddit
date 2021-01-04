//
//  RedditAPI.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

enum RedditAPIListingType : String {
    case top
    case hot
    case best
}

enum RedditAPI {
    
    enum Constants {
        static let baseURL = "https://www.reddit.com/"
    }
    
    case listing(RedditAPIListingType)
    
    var method: String {
        switch self {
        case .listing:
            return "GET"
        }
    }
    
    var endpointUrl: String {
        switch self {
        case .listing(let type):
            switch type {
            case .top:
                return Constants.baseURL + "top.json"
            case .hot:
                return Constants.baseURL + "hot.json"
            case .best:
                return Constants.baseURL + "best.json"
            }
        }
    }
}
