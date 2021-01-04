//
//  Resource.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

/**
 Generic struct to represent any loadable resource from any service, it has an urlRequest and a
 parse funcion.
 */
struct Resource<A> {
    var urlRequest: URLRequest
    let parse: (Data) -> A?
}

extension Resource {
    func map<B>(_ transform: @escaping (A) -> B) -> Resource<B> {
        return Resource<B>(urlRequest: urlRequest) { self.parse($0).map(transform) }
    }
}

extension Resource where A: Decodable {
    
    /**
     Create a resource object with URL
    */
    init(get url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }

    /**
     Create a resource object with URL and params
     */
    init(get url: URL, params: [String: String]) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        self.urlRequest = URLRequest(url: urlComponents!.url!)
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
    
    /**
     Create a resource object with URL and HttpMethod
     */
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>, cookies: String? = nil, token: String? = nil) {
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.method
        switch method {
        case .get: ()
        case .post(let body):
            self.urlRequest.httpBody = try? JSONEncoder().encode(body)
        }
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }

}
