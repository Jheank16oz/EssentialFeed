//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by jpineros on 9/02/22.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error>{
    case success([FeedItem])
    case failure(Error)
}

extension LoadFeedResult: Equatable where Error: Equatable{
    
}
protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion:@escaping (LoadFeedResult<Error>) -> Void)
}
