//
//  PostService.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol PostServiceProtocol: AnyObject {
    func getPosts(completion: @escaping ([Post]) -> Void)
}

class PostService: PostServiceProtocol {
    func getPosts(completion: @escaping ([Post]) -> Void) {
        completion([])
    }
}
