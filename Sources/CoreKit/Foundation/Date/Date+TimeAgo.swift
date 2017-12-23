//
//  Date+TimeAgo.swift
//  CoreKit
//
//  Created by Tibor Bödecs on 2017. 12. 10..
//  Copyright © 2017. Tibor Bödecs. All rights reserved.
//

import Foundation

public extension Date {

    public var timeAgo: String {
        let calander = Calendar.current
        let components = calander.dateComponents([.second, .minute, .hour, .day, .month, .year], from: self, to: Date())

        if let years = components.year, years > 0 {
            if years < 2 {
                return "Last year"
            }
            return "\(years) years ago"
        }

        if let months = components.month, months > 0 {
            if months < 2 {
                return "Last month"
            }
            return "\(months) months ago"
        }

        if let days = components.day, days >= 7 {
            let weeks = days / 7
            if weeks < 2 {
                return "Last week"
            }
            return "\(weeks) weeks ago"
        }

        if let days = components.day, days > 0 {
            if days < 2 {
                return "Yesterday"
            }
            return "\(days) days ago"
        }

        if let hours = components.hour, hours > 0 {
            if hours < 2 {
                return "An hour ago"
            }
            return "\(hours) hours ago"
        }

        if let minutes = components.minute, minutes > 0 {
            if minutes < 2 {
                return "A minute ago"
            }
            return "\(minutes) minutes ago"
        }

        if let seconds = components.second, seconds > 0 {
            if seconds < 5 {
                return "Just now"
            }
            return "\(seconds) seconds ago"
        }
        return ""
    }

}
