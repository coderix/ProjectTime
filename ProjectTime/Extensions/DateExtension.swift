//
//  DateExtension.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 03.06.21.
//

import Foundation
extension Date {

    /// Set the seconds of a date to zero
    /// - Parameter date: Date
    /// - Returns: Date with zero seconds
    static func dateWithZeroSeconds (date: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.second = 0
        return Calendar.current.date(from: components) ?? Date()

    }
}
