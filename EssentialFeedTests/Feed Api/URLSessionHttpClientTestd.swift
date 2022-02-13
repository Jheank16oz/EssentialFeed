//
//  URLSessionHttpClientTestd.swift
//  EssentialFeedTests
//
//  Created by jpineros on 13/02/22.
//

import Foundation
import XCTest

class URLSessionHTTPClient {
    private let session:URLSession
    init(session: URLSession){
        self.session = session
    }
    
    func get(from url: URL){
        session.dataTask(with: url, completionHandler: { _,_,_ in})
    }
}

class URLSessionHTTPClientTests: XCTestCase {


    func test_getFromURL_createsDataTaskWithURL(){
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session:session)
        sut.get(from:url)
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    // Mark - Helpers
    
    private class URLSessionSpy:URLSession {
        var receivedURLs = [URL]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask{}
}
