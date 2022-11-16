//
//  ExtensionTests.swift
//  ProjectTimeTests
//
//  Created by Dirk Newmann on 23.09.21.
//

import XCTest
import CoreData
@testable import ProjectTime

class ExtensionTests: BaseTestCase {

    func testDateWithZeroSeconds() {
        let date = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        components.second = 7
        let testDate = Calendar.current.date(from: components) ?? Date()

        let roundedDate = Date.dateWithZeroSeconds(date: testDate)

        components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: roundedDate)

        XCTAssertEqual(components.second, 0, "Seconds should be 0")

    }

    func testTimeIntervalHourMinute() {
        let date = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.year = 2021
        components.month = 10
        components.day = 10
        components.hour = 10
        components.minute = 10
        components.second = 7

        let startDate = Calendar.current.date(from: components) ?? Date()
        components.hour = 11
        let endDate = Calendar.current.date(from: components) ?? Date()
        XCTAssertEqual(endDate.timeIntervalSince(startDate).hourMinute, "1:00", "Interval should be 01:00")
    }
    
    

}
