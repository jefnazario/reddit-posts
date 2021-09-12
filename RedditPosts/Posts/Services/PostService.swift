//
//  PostService.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol PostServiceProtocol: AnyObject {
    func getPosts()
}

class PostService: PostServiceProtocol {
    weak var worker: PostsWorkerProtrocol?
    
    init(worker: PostsWorkerProtrocol) {
        self.worker = worker
    }
    
    func getPosts() {
        worker?.loadPosts()
    }
}
