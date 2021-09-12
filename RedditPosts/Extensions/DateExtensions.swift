//
//  DateExtensions.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 12/09/21.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            let timeText = diff == 1 ? "second" : "seconds"
            return "\(diff) \(timeText) ago"
        }
        
        if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            let timeText = diff == 1 ? "minute" : "minutes"
            return "\(diff) \(timeText) ago"
        }
        
        if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            let timeText = diff == 1 ? "hour" : "hours"
            return "\(diff) \(timeText) ago"
        }
        
        if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            let timeText = diff == 1 ? "day" : "days"
            return "\(diff) \(timeText) ago"
        }
        
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        let timeText = diff == 1 ? "week" : "weeks"
        return "\(diff) \(timeText) ago"
    }
}
