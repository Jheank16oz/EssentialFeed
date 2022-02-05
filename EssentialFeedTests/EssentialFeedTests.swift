//
//  EssentialFeedTests.swift
//  EssentialFeedTests
//
//  Created by jpineros on 31/01/22.
//

import XCTest
import EssentialFeed

class EssentialFeedTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
        
    }

    func test_load_requestsDataFromURL(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT()
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURL(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT()
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs, [ url, url])
    }
    
    func test_load_deliversErrorOnClientError(){
        let (sut, client) = makeSUT()

        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load {  capturedErrors.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    private func makeSUT(url:URL = URL(string:"http://a-given-url.com")!) ->(sut:
                                                                        RemoteFeedLoader, client:HTTPCLientSpy){
        let client = HTTPCLientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
        
    }
    
    private class HTTPCLientSpy:HTTPClient{
        var requestedURLs = [URL]()
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
        
        func complete(with error: Error, at index: Int = 0){
            completions[index](error)
        }
    }

}
