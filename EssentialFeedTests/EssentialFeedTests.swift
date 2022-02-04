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
    let url: URL
    
    init(url: URL, client:HTTPClient){
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
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
        let url = URL(string: "http://a-url.com")!
        let client = HTTPCLientSpy()
        _ = RemoteFeedLoader(url: url, client: client)
        XCTAssertNil(client.requestedURL)
        
    }

    func test_load_requestDataFromURL(){
        let url = URL(string: "http://a-given-url.com")!
        let client = HTTPCLientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }

}
