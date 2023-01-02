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

class PostsViewController: UITableViewController, StoryboardLoadable {
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
    @IBOutlet weak var emptyMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        service.getPosts()
    }
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
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
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let data = try? JSONEncoder().encode(presenter.posts) {
            coder.encode(data)
            super.encodeRestorableState(with: coder)
        }
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let data = coder.decodeData(), let posts = try? JSONDecoder().decode([Post].self, from: data) {
            presenter.posts = posts
        }
        super.decodeRestorableState(with: coder)
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
            self.refreshControl?.endRefreshing()
            
            self.setupBarButtonItem()
        }
    }
    
    func navigateToDetail(_ post: Post) {
        if let nav = (self.splitViewController?.viewControllers.last as? UINavigationController),
           let detail = (nav.topViewController as? PostDetailViewController) {
            detail.post = post
            detail.tableView?.reloadData()
            self.splitViewController?.hide(.primary)
        } else {
            let detail = UIStoryboard.loadViewController(withStoryboardName: "PostsStoryboard") as PostDetailViewController
            detail.post = post
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
}

extension PostsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: presenter.cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        let item = presenter.getItem(at: indexPath.row)
        cell.setup(item, at: indexPath.row, with: self)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: presenter.cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            return
        }
        
        let item = presenter.getItem(at: indexPath.row)
        cell.updateIsReaded(item)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        
        navigateToDetail(item)
    }
}

extension PostsViewController: UISplitViewControllerDelegate {
    
}
