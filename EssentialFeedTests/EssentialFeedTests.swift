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
        HTTPClient.shared.get(from:URL(string: "http://www.google.com")!)
    }
    
}

class HTTPClient {
    static var shared = HTTPClient()
    
    var requestedURL:URL?
    
    func get(from url: URL){}
    
}

class HTTPCLientSpy:HTTPClient{
    
    override func get(from url: URL){
        requestedURL = url
    }
}

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() throws {
        let client = HTTPCLientSpy()
        HTTPClient.shared  = client
        XCTAssertNil(client.requestedURL)
        
    }
    

    func test_load_requestDataFromURL(){
        let client = HTTPCLientSpy()
        HTTPClient.shared  = client
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }

}
