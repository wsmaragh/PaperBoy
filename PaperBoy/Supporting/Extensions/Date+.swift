//
//  Date+.swift
//  PaperBoy
//
//  Created by Winston Maragh on 9/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

extension Date {
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    var seconds: Int {
        return  Calendar.current.component(.second, from: self)
    }
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE")
        return dateFormatter.string(from: self)
    }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM")
        return dateFormatter.string(from: self)
    }
    
    
    // Methods
    
    // Returns a date string from the date.
    func dateString(for style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

    // Checks if a date is within the current date day.
    func isInCurrentDayWith(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }

    // Checks if a date is within the current date month.
    func isInCurrentMonthWith(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    // Returns a new date by adding the calendar component value.
    func adding(_ component: Calendar.Component, value: Int) -> Date? {
        return Calendar.current.date(byAdding: component, value: value, to: self)
    }
    
    func timeAgoSinceDate() -> String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        let componentTuple = [("year", components.year), ("month", components.month), ("week", components.weekOfYear), ("day", components.day), ("hour", components.hour), ("minute", components.minute), ("second", components.second)]
        
        for (word, time) in componentTuple {
            guard let time = time else { continue }
            if time >= 2 {
                return "\(time) \(word)s ago"
            } else if time >= 1 {
                return "1 \(word) ago"
            }
        }
        
        return "Just now"
    }
    
    static func getDateFromString(dateString: String) -> Date {
        let formmater = DateFormatter()
        formmater.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let newDate = formmater.date(from: dateString) else {return Date()}
        return newDate
    }
    
    static func timeAgoSinceDate(dateString: String) -> String {
        let date = getDateFromString(dateString: dateString)
        
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        let componentTuple = [("year", components.year), ("month", components.month), ("week", components.weekOfYear), ("day", components.day), ("hour", components.hour), ("minute", components.minute), ("second", components.second)]
        
        for (word, time) in componentTuple {
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
