//
//  PostsTableViewCell.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var readedSignal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ post: Post) {
        let date = post.createdUtc?.intToDate()
        time.text = date?.timeAgoDisplay()
        commentsCount.text = post.numComments?.commentsLabel()
        username.text = post.author
        textContent.text = post.title
        
        readedSignal.isHidden = false
        if let postId = post.id {
            let isReaded = UserDefaults.standard.bool(forKey: postId)
            readedSignal.isHidden = isReaded
            
            username.font = isReaded ? .systemFont(ofSize: 16, weight: .bold) : .systemFont(ofSize: 16, weight: .black)
            textContent.font = isReaded ? .systemFont(ofSize: 15, weight: .regular) : .systemFont(ofSize: 15, weight: .bold)
        }
        
        guard let media = post.media,
              let embed = media.oembed,
              let thumbUrl = embed.thumbnailURL else {
            postImage.isHidden = true
            return
        }
        
        postImage.isHidden = false
        postImage.load(from: thumbUrl)
    }
    
    func updateIsReaded(_ post: Post) {
        guard let postId = post.id else { return }
        UserDefaults.standard.set(true, forKey: postId)
    }
}
