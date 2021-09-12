//
//  PostsPresenter.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol PostsPresenterProtocol: AnyObject {
    var posts: [Post] { get set }
    var cellIdentifier: String { get }
    
    func handleLoad(_ posts: [Post])
    func handleError(_ message: String)
}

class PostsPresenter: PostsPresenterProtocol {
    var cellIdentifier: String = "postsCell"
    var posts: [Post] = []
    
    weak var view: PostsViewProtocol?
    
    init(view: PostsViewProtocol) {
        self.view = view
        
    }
    
    func handleError(_ message: String) {
        //
    }
    
    func handleLoad(_ posts: [Post]) {
        self.posts = posts
        view?.reloadScreen()
    }
}
