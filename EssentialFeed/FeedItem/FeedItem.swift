//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by jpineros on 6/02/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id:UUID
    let description: String?
    let location:String?
    let imageURL: URL
}
