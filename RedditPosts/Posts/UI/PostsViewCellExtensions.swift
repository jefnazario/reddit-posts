//
//  PostsViewCellExtensions.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import UIKit

extension PostsTableViewCell {
    // MARK: - Image handle
    @objc func saveImage() {
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
}
