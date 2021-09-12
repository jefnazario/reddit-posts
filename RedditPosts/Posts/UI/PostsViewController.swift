//
//  PostsViewController.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import UIKit

protocol PostsViewProtocol: AnyObject {
    func reloadScreen()
    func dismissPost(at indexPath: Int)
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
    
    private func setupBarButtonItem() {
        guard presenter.posts.count > 0 else {
            let load = UIBarButtonItem(title: "Load posts", style: .plain, target: self, action: #selector(reload))
            navigationItem.setRightBarButton(load, animated: true)
            return
        }
        let dismissAll = UIBarButtonItem(title: "Dismiss All", style: .plain, target: self, action: #selector(dissmissAllPosts))
        navigationItem.setRightBarButton(dismissAll, animated: true)
    }
    
    @objc private func dissmissAllPosts() {
        var indexes = [IndexPath]()
        for (index, _) in presenter.posts.enumerated() {
            indexes.append(IndexPath(row: index, section: 0))
        }
        presenter.dismissPost(at: -1)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: indexes, with: .fade)
        tableView.endUpdates()
        
        tableView.isHidden = true
        setupBarButtonItem()
    }
    
    @objc private func reload() {
        service.getPosts()
    }
}

extension PostsViewController: PostsViewProtocol {
    func dismissPost(at indexPath: Int) {
        presenter.dismissPost(at: indexPath)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: indexPath, section: 0)], with: .fade)
        tableView.endUpdates()
        
        if let indexes = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: indexes, with: .none)
        }
    }
    
    func reloadScreen() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            self.setupBarButtonItem()
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
        cell.setup(item, at: indexPath.row, with: self)
        
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
