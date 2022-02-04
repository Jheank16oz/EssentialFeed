//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by jpineros on 31/01/22.
//

import XCTest
@testable import EssentialFeed

class RemoteFeedLoader {
    
    let client: HTTPClient
    
    init(client:HTTPClient){
        self.client = client
    }
    
    func load() {
        client.get(from:URL(string: "http://www.google.com")!)
    }
    
}

protocol HTTPClient {
    
    func get(from url: URL)
    
}

class HTTPCLientSpy:HTTPClient{
    var requestedURL:URL?
    
    func get(from url: URL){
        requestedURL = url
    }
}

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() throws {
        let client = HTTPCLientSpy()
        XCTAssertNil(client.requestedURL)
        
    }

    func test_load_requestDataFromURL(){
        let client = HTTPCLientSpy()
        let sut = RemoteFeedLoader(client: client)
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }

}
