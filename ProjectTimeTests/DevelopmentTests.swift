//
//  DevelopmentTests.swift
//  ProjectTimeTests
//
//  Created by Dirk Newmann on 22.09.21.
//

import CoreData
import XCTest
@testable import ProjectTime

class DevelopmentTests: BaseTestCase {

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.initializeDatabase()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "deleteAll() should leave 0 projects.")
        XCTAssertEqual(dataController.count(for: Client.fetchRequest()), 0, "deleteAll() should leave 0 clients.")
        XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 0, "deleteAll() should leave 0 activities.")
        XCTAssertEqual(dataController.count(for: Hour.fetchRequest()), 0, "deleteAll() should leave 0 hours.")
    }

    func testExampleTaskTitle() {
        let task = Task.example
        XCTAssertEqual(task.title, "Example Task", "The title of example item should be Example Task.")
    }

    func testExampleClientName() {
        let client = Client.example
        XCTAssertEqual(client.name, "Example Client", "The name example client should be Example Client.")
    }
}
