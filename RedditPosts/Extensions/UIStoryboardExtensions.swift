//
//  UIStoryboardExtensions.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 13/09/21.
//

import Foundation
import UIKit

protocol StoryboardLoadable {
    static func storyboardName() -> String
    static func storyboardIdentifier() -> String
}

extension StoryboardLoadable where Self: UIViewController {
    static func storyboardName() -> String {
        return String(describing: Self.self).replacingOccurrences(of: "ViewController", with: "")
    }
    
    static func storyboardIdentifier() -> String {
        return String(describing: Self.self)
    }
}

extension UIStoryboard {
    static func loadViewController<T>() -> T where T: StoryboardLoadable, T: UIViewController {
        // swiftlint:disable:next force_cast
        return UIStoryboard(name: T.storyboardName(), bundle: nil).instantiateViewController(withIdentifier: T.storyboardIdentifier()) as! T
    }
    
    static func loadViewController<T>(withStoryboardName storyboardName: String) -> T where T: StoryboardLoadable, T: UIViewController {
        // swiftlint:disable:next force_cast
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: T.storyboardIdentifier()) as! T
    }
}
