//
//  DateformatterService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

struct DateFormatterService {

    private init() {}
    static let shared = DateFormatterService()

    private let formatter = DateFormatter()

    public func getCustomDateTimeAgoForArticleCell(dateStr: String) -> String {
        let date = getDate(from: dateStr, inputDateStringFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        return timeAgoSinceDate(date)
    }
    
    public func getCustomDateStringForArticleView(dateStr: String) -> String {
        let date = getDate(from: dateStr, inputDateStringFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        return getDateString(from: date, dateStyle: .medium, dateTime: .none)
    }
    
    // String -> Date
    public func getDate(from dateString: String,
                        inputDateStringFormat inputFormat: String) -> Date {
        formatter.dateFormat = inputFormat
        let date = formatter.date(from: dateString)!
        return date
    }
    
    // Date -> String
    public func getDateString(from date: Date,
                              dateStyle: DateFormatter.Style,
                              dateTime: DateFormatter.Style) -> String {
        formatter.dateStyle = dateStyle
        formatter.timeStyle = dateTime
        let newDateString = formatter.string(from: date)
        return newDateString
    }
    
    // Date -> String
    public func getCustomDateString(from date: Date,
                                    customDateFormat dateFormat: String) -> String {
        formatter.dateFormat = dateFormat
        let newDateString = formatter.string(from: date)
        return newDateString
    }
    
    // Date -> String
    public func getUpdatedString(from date: Date) -> String {
        formatter.dateFormat = "MMMM dd, h:mm a"
        let newDateString = formatter.string(from: date)
        let newFormateDateString = newDateString.replacingOccurrences(of: ",", with: " at")
        return newFormateDateString
    }
    
    // String -> String
    public func getReformattedDateString(from dateString: String,
                                         inputDateFormat inputFormat: String,
                                         outputDateFormat outputFormat: String) -> String {
        formatter.dateFormat = inputFormat
        guard let date = formatter.date(from: dateString) else {return "invalid date"}
        formatter.dateFormat = outputFormat
        let newDateString = formatter.string(from: date)
        return newDateString
    }
    
    // Date -> String
    public func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }

    }
}
