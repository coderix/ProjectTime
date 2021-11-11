//
//  TimeIntervalExtension.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 31.05.21.
//

import Foundation
extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format: "%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }

    var hourMinuteSecond: String {
        String(format: "%d:%02d:%02d", hour, minute, second)
    }
    var hourMinute: String {
        String(format: "%d:%02d", hour, minute)
    }
    var minuteSecondMS: String {
        String(format: "%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
