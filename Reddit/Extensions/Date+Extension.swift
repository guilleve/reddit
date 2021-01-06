//
//  Date+extension.swift
//  Reddit
//
//  Created by Guillermo Vergara on 1/6/21.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let interval = Calendar.current.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: Date())
        var timeStr = ""
        if let year = interval.year, year > 0 {
            timeStr = (year == 1 ? "a year" : "\(year) years")
        } else if let month = interval.month, month > 0 {
            timeStr = (month == 1 ? "a month" : "\(month) months")
        } else if let weekOfYear = interval.weekOfYear, weekOfYear > 0 {
            timeStr = (weekOfYear == 1 ? "a week" : "\(weekOfYear) weeks")
        } else if let day = interval.day, day > 0 {
            timeStr = (day == 1 ? "a day" : "\(day) days")
        } else if let hour = interval.hour, hour > 0 {
            timeStr = (hour == 1 ? "a hour" : "\(hour) hours")
        } else if let minute = interval.minute, minute > 0 {
            timeStr = (minute == 1 ? "a minute" : "\(minute) minutes")
        } else if let second = interval.second, second > 0 {
            timeStr = (second == 1 ? "a second" : "\(second) seconds")
        } else {
            timeStr = "a moment"
        }
        return timeStr + " ago"
    }
}
