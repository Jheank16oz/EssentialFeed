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
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURL(){
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT()
        sut.load { _ in }
        sut.load { _ in }
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
    
    func test_load_deliversErrorOnNonHTTPResponse(){
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach{ index, code in
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load {  capturedErrors.append($0) }
            
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedErrors, [.invalidData])
        }
        
    }
    
    
    // MARK: - Helpers
    private func makeSUT(url:URL = URL(string:"http://a-given-url.com")!) ->(sut:
                                                                        RemoteFeedLoader, client:HTTPCLientSpy){
        let client = HTTPCLientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
        
    }
    
    private class HTTPCLientSpy:HTTPClient{
        var requestedURLs : [URL]{
            return messages.map{ $0.url }
        }
        var messages = [(url:URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        
        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0){
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0){
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )
            messages[index].completion(nil, response)
        }
    }

}
