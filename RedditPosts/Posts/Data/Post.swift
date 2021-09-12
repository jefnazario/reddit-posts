//
//  Post.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation
import CoreData

// MARK: - Reddit
struct Reddit: Decodable {
    let kind: String?
    let data: RedditData?
}

// MARK: - RedditData
struct RedditData: Decodable {
    let after: String?
    let dist: Int?
    let children: [Child]?
}

// MARK: - Child
struct Child: Decodable {
    let kind: String?
    let data: Post
}

// MARK: - Child data: Post
struct Post: Decodable {
    let title: String?
    let author: String?
    let createdUtc: Int?
    let numComments: Int?
    let selftext: String?
    
    enum CodingKeys: String, CodingKey {
        case title, author, selftext
        case createdUtc = "created_utc"
        case numComments = "num_comments"
    }
}
