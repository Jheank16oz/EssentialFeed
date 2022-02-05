//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by jpineros on 5/02/22.
//

import Foundation


public protocol HTTPClient {
    
    func get(from url: URL)
    
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL, client:HTTPClient){
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
    
}
