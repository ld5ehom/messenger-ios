//
//  Date+Extension.swift
//  Messenger-ios
//
//  Created by TaeWook Park on 8/20/24.
//

import Foundation

/**
 Task 4: Converts a Date object to a formatted String.
 */
extension Date {
    
    init?(year: Int, month: Int, day: Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        guard let date = Calendar.current.date(from: components) else {
            return nil
        }
        self = date
    }
    
    var toChatTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a" // 12-hour format with AM/PM
        return formatter.string(from: self)
    }
    
    var toChatTimeAccessibility: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a" // Keeping it the same for simplicity
        return formatter.string(from: self)
    }
    
    var toChatDataKey: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy/MM/dd E" // U.S. typically uses slashes
        return formatter.string(from: self)
    }
    
    var toChatDataAccessibility: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, MMMM dd, yyyy" // Full date with weekday
        return formatter.string(from: self)
    }
}

extension String {
    
    var toChatDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy/MM/dd E" // Matching U.S. format
        return formatter.date(from: self)
    }
}
