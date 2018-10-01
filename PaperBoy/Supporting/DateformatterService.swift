//
//  DateformatterService.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

import Foundation

struct DateFormatterService {
    
    private init(){}
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
    public func timeAgoSinceDate(_ date:Date, numericDates: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    /*
     Built-in Date Format Styles
     ||---------------------------------------------------------------------------------||
     || DateFormatter |                            |                                    ||
     ||     Style     |        Date                |           Time                     ||
     ||---------------------------------------------------------------------------------||
     ||  .none        |                            |                                    ||
     ||  .short       | "12/25/16"                 | “6:00 AM”                          ||
     ||  .medium      | "Dec 25, 2016"             | “6:00:00 AM”                       ||
     ||  .long        | "December 25, 2016"        | “6:00:00 AM EST”                   ||
     ||  .full        | “Sunday December 25, 2016” | “6:00:00 AM Eastern Standard Time” ||
     --------------------------------------------------------------------------------------
     
     
     ** Date Formats Key **
     ||--------------------------------------------------------------||
     ||   Format    ||        Description     ||    Example output   ||
     ||--------------------------------------------------------------||
     ||  yy         ||    Two-digit year      ||   16, 14, 04        ||
     ||  yyyy       ||    Four-digit year     ||   2016, 2014, 2004  ||
     ||  MM         ||    Two-digit month     ||   06, 08, 12        ||
     ||  MMM        ||    Three-letter month  ||   Jul, Aug, Dec     ||
     ||  MMMM       ||    Full month name     ||   July, August      ||
     ||  dd         ||    Two-digit day       ||   10, 11, 30        ||
     ||  EEE        ||    Three-letter day    ||   Mon, Sat, Sun     ||
     ||  EEEE       ||    Full day            ||   Thursday, Sunday  ||
     ----------------------------------------------------------------
     ||  a          ||    Period of day       ||   AM, PM            ||
     ||  hh         || Two-digit hour (12hr)  ||   02, 03, 04        ||
     ||  HH         || Two-digit hour (24hr)  ||   11, 14, 16        ||
     ||  mm         ||    Two-digit minute    ||   30, 35, 45        ||
     ||  ss         ||    Two-digit seconds   ||   30, 35, 45        ||
     ----------------------------------------------------------------
     
     
     ______________ Date Combinations _________________
     ||-----------------------------------------------------------------||
     || Thursday, Oct 12, 2017             | "EEEE, MMM d, yyyy"        ||
     || 10/12/2017                         | "MM/dd/yyyy"               ||
     || 10-12-2017 09:48                   | "MM-dd-yyyy HH:mm"         ||
     || Oct 12, 9:48 AM                    | "MMM d, h:mm a"            ||
     || October 2017                       | "MMMM yyyy"                ||
     || Oct 12, 2017                       | "MMM d, yyyy"              ||
     || Thu, 12 Oct 2017 09:48:59 +0000    | "E, d MMM yyyy HH:mm:ss Z" ||
     || 2017-10-12T09:48:59+0000           | "yyyy-MM-dd'T'HH:mm:ssZ"   ||
     || 12.10.17                           | "dd.MM.yy"                 ||
     --------------------------------------------------------------------
     2018-09-26T12:01:53Z
     yyyy-MM-dd'T'HH:mm:ssZ
     
     */
    
}
