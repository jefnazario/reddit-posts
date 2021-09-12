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
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(reload), for: .valueChanged)
        return refresh
    }()
    
    // MARK: - IBOutlet properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(refreshControl)
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
            self.refreshControl.endRefreshing()
        }
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: presenter.cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        let item = presenter.getItem(at: indexPath.row)
        cell.setup(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: presenter.cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            return
        }
        
        let item = presenter.getItem(at: indexPath.row)
        cell.updateIsReaded(item)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}
