//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by jpineros on 9/02/22.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion:@escaping (LoadFeedResult) -> Void)
}
