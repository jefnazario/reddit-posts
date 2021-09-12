//
//  PostsViewController.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import UIKit

protocol PostsViewProtocol: AnyObject {
    func reloadScreen()
}

class PostsViewController: UIViewController {
    // MARK: - Instantiate lazy var
    private lazy var api: ApiProtocol = {
        return Api()
    }()
    
    private lazy var presenter: PostsPresenterProtocol = {
        return PostsPresenter(view: self)
    }()
    
    private lazy var worker: PostsWorkerProtrocol = {
        return PostsWorker(api: self.api, presenter: self.presenter)
    }()
    
    private lazy var service: PostServiceProtocol = {
        return PostService(worker: self.worker)
    }()
    
    // MARK: - IBOutlet properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.getPosts()
    }
    
    @objc func reload() {
        service.getPosts()
    }
}

extension PostsViewController: PostsViewProtocol {
    func reloadScreen() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: presenter.cellIdentifier, for: indexPath)
        cell.textLabel?.text = presenter.posts[indexPath.row].title
        
        return cell
    }
}
