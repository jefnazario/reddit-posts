//
//  PostsWorker.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol PostsWorkerProtrocol: AnyObject {
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void)
}

class PostsWorker: PostsWorkerProtrocol {
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        
    }
}
