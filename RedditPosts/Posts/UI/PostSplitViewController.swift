//
//  PostSplitViewController.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import UIKit

class PostSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        self.preferredDisplayMode = .allVisible
        self.delegate = self
    }
}

extension PostSplitViewController: UISplitViewControllerDelegate {
    @available(iOS 14.0, *)
        public func splitViewController(_ svc: UISplitViewController,
            topColumnForCollapsingToProposedTopColumn
            proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
            return .primary
        }

        public func splitViewController(_ splitViewController: UISplitViewController,
                                 collapseSecondary secondaryViewController:UIViewController,
                                 onto primaryViewController:UIViewController) -> Bool {
            return true
        }
}
