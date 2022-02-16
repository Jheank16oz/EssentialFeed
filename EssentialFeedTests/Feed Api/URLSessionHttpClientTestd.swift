//
//  URLSessionHttpClientTestd.swift
//  EssentialFeedTests
//
//  Created by jpineros on 13/02/22.
//

import Foundation
import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    
    private let session:URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void){
        session.dataTask(with: url) { _,_,error in
            if let error = error {
                completion(.failure(error))
            }
        
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_failsOnRequesError(){
        URLProtocolStub.startInterceptingRequest()
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data:nil, response:nil, error: error)
        
        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "wait for completion")
        sut.get(from:url){ result in
            switch result {
            case let .failure(receiveError as NSError):
                XCTAssertEqual(receiveError.domain, error.domain)
                default:
                    XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequest()
    }
    
    // Mark - Helpers
    
    private class URLProtocolStub:URLProtocol {
        private static var stub:Stub?
        
        private struct Stub{
            let data: Data?
            let response:URLResponse?
            let error: Error?
        }
        
        static func startInterceptingRequest(){
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest(){
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        
        static func stub(data: Data?, response: URLResponse?, error:Error? = nil){
            stub = Stub(data:data, response:response, error: error)
        }

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data{
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let respnse = URLProtocolStub.stub?.response{
                client?.urlProtocol(self, didReceive: respnse, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol( self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}

    }
}
