//
//  PostsTableViewCell.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ post: Post) {
        self.post = post
        time.text = post.createdUtc?.description
        username.text = post.author
        textContent.text = post.title
        
    }
}
