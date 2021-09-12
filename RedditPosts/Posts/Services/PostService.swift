//
//  PostService.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol PostServiceProtocol: AnyObject {
    var posts: [Post] { get set }
    func getPosts()
}

class PostService: PostServiceProtocol {
    var posts: [Post] = []
    weak var worker: PostsWorkerProtrocol?
    
    init(worker: PostsWorkerProtrocol) {
        self.worker = worker
    }
    
    func getPosts() {
        worker?.loadPosts()
    }
}
