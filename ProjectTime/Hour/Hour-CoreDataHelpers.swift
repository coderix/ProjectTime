//
//  Hour-CoreDataHelpers.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 21.05.21.
//

import Foundation
extension Hour {

    var hourDetails: String {
        details ?? ""

    }

    var hourStart: Date {
        start ?? Date()
    }
    var hourEnd: Date {
        end ?? Date()
    }

    var formattedStartTime: String {
        return hourFormatter(date: start ?? Date())
    }

    var formattedStartDay: String {
        return dayMonthYear(date: start ?? Date())
    }

    var formattedEndTime: String {
        return hourFormatter(date: end ?? Date())
    }

    var formattedEndDay: String {
        return dayMonthYear(date: end ?? Date())
    }
    func dayMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let dateString = formatter.string(from: date)
        return dateString
    }

    /**
     ignore seconds
     */
    func hourFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }

    var duration: TimeInterval {
        return hourEnd.timeIntervalSince(hourStart)

    }

    var durationString: String {
        return duration.hourMinute
        // return String(duration.hour) + ":" + String(duration.minute)
    }

}
