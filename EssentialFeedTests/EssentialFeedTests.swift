//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by jpineros on 31/01/22.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "http://www.google.com")
    }
    
}

class HTTPClient {
    static let shared = HTTPClient()
    
    private init(){
        
    }
    
    var requestedURL:URL?
}

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() throws {
        let client = HTTPClient.shared
        _  = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
        
    }
    

    func test_load_requestDataFromURL(){
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }

}
