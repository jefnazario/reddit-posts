//
//  UIViewExtensions.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import UIKit

extension UIView {
    func showsSaveShareMenu(with title: String, for itemName: String, saveClosure: @escaping () -> Void, shareClosure: @escaping () -> Void) {
        let menu = UIAlertController(title: title, message: "What do you want to do?", preferredStyle: .actionSheet)
        let save = UIAlertAction(title: "Save \(itemName)", style: .default) { _ in
            saveClosure()
        }
        
        let share = UIAlertAction(title: "Share \(itemName)", style: .default) { _ in
            shareClosure()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        menu.addAction(save)
        menu.addAction(share)
        menu.addAction(cancel)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
          while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
          }
          topController.present(menu, animated: true)
        }
    }
    
    func showsActivityController(items: [Any]) {
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
          while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
          }
          topController.present(activityController, animated: true)
        }
    }
}
