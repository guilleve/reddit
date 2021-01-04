//
//  HttpMethod.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}
