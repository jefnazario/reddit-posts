//
//  Post.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation
import CoreData

// MARK: - Reddit
struct Reddit: Codable {
    let kind: String?
    let data: RedditData?
}

// MARK: - RedditData
struct RedditData: Codable {
    let after: String?
    let dist: Int?
    let children: [Child]?
}

// MARK: - Child
struct Child: Codable {
    let kind: String?
    let data: Post
}

// MARK: - Child data: Post
struct Post: Codable {
    let title: String?
    let author: String?
    let createdUtc: Int?
    let numComments: Int?
    let selftext: String?
    let media: Media?
    let id: String?
    
    var isReaded: Bool = false
    
    func key() -> String {
        let str = "\(createdUtc ?? 0)\(author?.lowercased().replacingOccurrences(of: " ", with: "") ?? "")"
        return str
    }
    
    enum CodingKeys: String, CodingKey {
        case title, author, selftext, media, id
        case createdUtc = "created_utc"
        case numComments = "num_comments"
    }
}

// MARK: - Media
struct Media: Codable {
    let oembed: Oembed?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case oembed, type
    }
}

// MARK: - Oembed
struct Oembed: Codable {
    let providerURL: String
    let url: String?
    let html, authorName: String
    let height: Int?
    let width: Int
    let version: String
    let authorURL: String?
    let providerName: String
    let cacheAge: Int?
    let type: String
    let oembedDescription, title: String?
    let thumbnailWidth: Int?
    let thumbnailURL: String?
    let thumbnailHeight: Int?

    enum CodingKeys: String, CodingKey {
        case providerURL = "provider_url"
        case url, html
        case authorName = "author_name"
        case height, width, version
        case authorURL = "author_url"
        case providerName = "provider_name"
        case cacheAge = "cache_age"
        case type
        case oembedDescription = "description"
        case title
        case thumbnailWidth = "thumbnail_width"
        case thumbnailURL = "thumbnail_url"
        case thumbnailHeight = "thumbnail_height"
    }
}
