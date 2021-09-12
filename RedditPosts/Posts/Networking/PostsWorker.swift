//
//  PostsWorker.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol PostsWorkerProtrocol: AnyObject {
    func loadPosts()
}

class PostsWorker: PostsWorkerProtrocol {
    weak var api: ApiProtocol?
    weak var presenter: PostsPresenterProtocol?
    
    init(api: ApiProtocol, presenter: PostsPresenterProtocol) {
        self.api = api
        self.presenter = presenter
    }
    
    func loadPosts() {
        api?.request(method: HttpMethod.get, url: Endpoints.top, json: nil) {[weak self] (result: ApiResponse<Reddit>) in
            guard let self = self else {
                self?.presenter?.handleError("Load posts failure.")
                return
            }
            
            switch result {
            case .success(let redditPosts):
                guard let posts = redditPosts.data?.children?.map({ child in
                    child.data
                }) else {
                    self.presenter?.handleError("Load posts failure.")
                    return
                }
                self.presenter?.handleLoad(posts)
            case .error(let message):
                self.presenter?.handleError(message)
            }
        }
    }
}
