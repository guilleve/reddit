//
//  MockUrlSession.swift
//  RedditTests
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation
@testable import Reddit

class MockURLSession: URLSessionProtocol {

    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url

        completionHandler(nextDataTask.nextData, nextDataTask.nextUrlResponse, nextDataTask.nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    var nextData: Data?
    var nextError: Error?
    var nextUrlResponse: URLResponse?

    func resume() {
        resumeWasCalled = true
    }
}
