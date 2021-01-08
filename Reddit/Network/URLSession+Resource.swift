//
//  URLSession+Resource.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/4/21.
//

import Foundation

/**
 Protocol used to do dependency injection in our services, avoiding the direct dependency with cocrete
 instances of URLSession.
 */
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A, ServiceError>) -> Void)
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSessionProtocol {
    /**
     Creates a task that retrieves the contents of a Resource based on its specified URL
     request object, and calls a completion when done.
     */
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A, ServiceError>) -> Void) {
        
        dataTask(with: resource.urlRequest) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.requestError(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noDataError))
                }
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.responseFailError))
                }
                return
            }
            
            guard let result = resource.parse(data) else {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(result))
            }
        }.resume()
    }
}

