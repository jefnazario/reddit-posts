//
//  PostDetailViewController.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 13/09/21.
//

import UIKit

class PostDetailViewController: UIViewController, StoryboardLoadable {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var messageLabel: UILabel?
    
    var cellIdentifier: String = "postDetailCell"
    var post: Post? {
        didSet {
            tableView?.isHidden = post == nil
            messageLabel?.isHidden = post != nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView?.isHidden = post == nil
        messageLabel?.isHidden = post != nil
    }
    
    func reloadData() {
        tableView?.reloadData()
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let data = try? JSONEncoder().encode(self.post) {
            coder.encode(data)
            super.encodeRestorableState(with: coder)
        }
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let data = coder.decodeData(), let post = try? JSONDecoder().decode(Post.self, from: data) {
            self.post = post
        }
        super.decodeRestorableState(with: coder)
    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? PostsTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = self.post {
            cell.setup(item, at: indexPath.row)
        }
        cell.customSetupForDetail()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
