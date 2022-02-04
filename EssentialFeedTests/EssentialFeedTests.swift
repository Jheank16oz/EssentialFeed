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



class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertNil(client.requestedURL)
        
    }

    func test_load_requestDataFromURL(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT()
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    private func makeSUT(url:URL = URL(string:"http://a-given-url.com")!) ->(sut:
                                                                        RemoteFeedLoader, client:HTTPCLientSpy){
        let client = HTTPCLientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
        
    }
    
    private class HTTPCLientSpy:HTTPClient{
        var requestedURL:URL?
        
        func get(from url: URL){
            requestedURL = url
        }
    }

}
