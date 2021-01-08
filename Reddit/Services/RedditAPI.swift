//
//  RedditAPI.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

/**
 Reddit API according to documentation (http://www.reddit.com/dev/api)
 */
enum RedditAPI {
    
    enum ListingType : String {
        case top
        case hot
        case best
    }
    
    enum Constants {
        static let baseURL = "https://www.reddit.com/"
    }
    
    case listing(ListingType)
    
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
