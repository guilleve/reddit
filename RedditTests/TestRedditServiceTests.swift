//
//  TestRedditService.swift
//  RedditTests
//
//  Created by Guillermo Vergara on 1/7/21.
//

import Foundation
import XCTest
@testable import Reddit

class TestRedditServiceTests: XCTestCase {
    
    var service: RedditService!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        self.service = RedditService(urlSession: session)
    }
    
    func testListingPost() {
        
        let dataTask = MockURLSessionDataTask()
        let resource = Bundle(for: type(of: self)).url(forResource: "top", withExtension: "json")

        do {
            let expectedData = try? Data(contentsOf: resource!)
            dataTask.nextData = expectedData
            let url = URL(string: "url.reddit.com")
            dataTask.nextUrlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
            session.nextDataTask = dataTask
            
            var actual: ListingResponse?
            let expectation = self.expectation(description: "Getting post Data")
            service.listing(listingType: .top,
                            count: 5) { result in
                switch result {
                case .success(let response):
                    actual = response
                case .failure(_):
                    XCTFail()
                }
                expectation.fulfill()
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNotNil(actual, "actual should not be nil")
            XCTAssertEqual(actual?.data.children[0].data.id, "t3_2hqlxp")
            XCTAssertEqual(actual?.data.children[0].data.title, "Man trying to return a dog's toy gets tricked into playing fetch")
        }
    }
    
}
