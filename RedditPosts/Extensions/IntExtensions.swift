//
//  IntExtensions.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import Foundation

extension Int {
    func intToDate() -> Date {
        let interval: TimeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: interval)
        return date
    }
    
    func commentsLabel() -> String {
        var text = "\(self) comments"
        if self == 1 {
            text = text.replacingOccurrences(of: "s", with: "")
        }
        
        return text
    }
}
