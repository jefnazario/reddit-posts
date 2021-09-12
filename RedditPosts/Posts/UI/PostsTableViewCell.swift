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
    @IBOutlet weak var dismissButton: UIButton!
    
    weak var postDelegate: PostsViewProtocol?
    var postId: String = String()
    var indexPath: Int = 0
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveImage))
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ post: Post, at indexPath: Int, with delegate: PostsViewProtocol) {
        self.postDelegate = delegate
        self.indexPath = indexPath
        
        let date = post.createdUtc?.intToDate()
        time.text = date?.timeAgoDisplay()
        commentsCount.text = post.numComments?.commentsLabel()
        username.text = post.author
        textContent.text = post.title
        
        readedSignal.isHidden = false
        if let postId = post.id {
            self.postId = postId
            
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
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(tapGesture)
        postImage.load(from: thumbUrl)
    }
    
    func updateIsReaded(_ post: Post) {
        guard let postId = post.id else { return }
        UserDefaults.standard.set(true, forKey: postId)
    }
    
    // MARK: - IBActions
    @IBAction func dismissPost() {
        postDelegate?.dismissPost(at: indexPath)
    }
}
