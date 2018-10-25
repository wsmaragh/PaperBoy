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
    
    func timeAgoSinceDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        let componentDict = ["year": components.year, "month": components.month, "week": components.weekOfYear, "day": components.day, "hour": components.hour, "minute": components.minute,  "second": components.second]
        
        for (word, time) in componentDict {
            guard let time = time else { continue }
            if time >= 2 {
                return "\(time) \(word)s ago"
            } else if time >= 1 {
                return "1 \(word) ago"
            }
        }
        
        return "Just now"
    }
 
}
