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
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveImage))
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    @objc private func saveImage() {
        guard let image = self.postImage.image else { return }
        
        showsSaveShareMenu(with: "", for: "image") {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        } shareClosure: {
            self.showsActivityController(items: [image])
        }
    }
    
    //MARK: - Add image to Library
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            print("title: Save error, message: \(error!.localizedDescription)")
            return
        }
        
        print("title: Saved!, message: Your image has been saved to your photos.)")
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
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(tapGesture)
        postImage.load(from: thumbUrl)
    }
    
    func updateIsReaded(_ post: Post) {
        guard let postId = post.id else { return }
        UserDefaults.standard.set(true, forKey: postId)
    }
}
