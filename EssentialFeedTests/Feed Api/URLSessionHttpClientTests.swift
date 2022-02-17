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
    
    struct UnexpectedValuesRepresentation: Error{
        
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void){
        session.dataTask(with: url) { _,_,error in
            if let error = error {
                completion(.failure(error))
            }else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }
    
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    func test_getFromURL_performsGETRequestWithURL(){
        
        
        let exp = expectation(description: "wait for request")
        let url = anyURL()
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        makeSUT().get(from: url){ _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequesError(){
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data:nil, response:nil, error: error)
        
        let exp = expectation(description: "wait for completion")
        makeSUT().get(from:anyURL()){ result in
            switch result {
            case let .failure(receiveError as NSError):
                XCTAssertEqual(receiveError.domain, error.domain)
                default:
                    XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnAllNilValues(){
        URLProtocolStub.stub(data:nil, response:nil, error: nil)
        
        let exp = expectation(description: "wait for completion")
        makeSUT().get(from:anyURL()){ result in
            switch result {
            case .failure:
                break
                default:
                    XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    // Mark - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut,file: file, line: line)
        return sut
    }
    
    private func anyURL() -> URL{
        return URL(string: "http://any-url.com")!
    }
    private class URLProtocolStub:URLProtocol {
        private static var stub:Stub?
        private static var requestObserver:((URLRequest) -> Void)?
        
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
            requestObserver = nil
        }
        
        static func stub(data: Data?, response: URLResponse?, error:Error? = nil){
            stub = Stub(data:data, response:response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void){
            requestObserver = observer
        }

        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
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
