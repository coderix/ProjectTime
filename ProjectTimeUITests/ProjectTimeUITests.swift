//
//  ProjectTimeUITests.swift
//  ProjectTimeUITests
//
//  Created by Dirk Newmann on 26.09.21.
//

import XCTest
import SwiftUI

class ProjectTimeUITests: XCTestCase {
    var app = XCUIApplication()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
        // - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testAppHas2Tabs() throws {
        // UI tests must launch the application that they test.

        XCTAssertEqual(app.tabBars.buttons.count, 2, "There should be 2 tabs in the app")
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testCreateTask() {
        app.buttons["Home"].tap()
        app.buttons["Tasks"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row initially")

        // you must enter a title for the activity before you can create one
        app.buttons["Add this Task"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row initially")

        // create new activity with a title
        app.textFields["New Task"].tap()
        app.textFields["New Task"].typeText("Development")
        app.buttons["Add this Task"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding a project.")

    }
    func testCreateClient() {
        testCreateTask()
        let tabBar = app.tabBars["Tab Bar"]

        // Open ClientsView
        tabBar.buttons["Clients"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no client list rows initially")

        // create new client
        app.buttons["Add new client"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

    }

    func testEditClient() {

        testCreateClient()
        let tabBar = app.tabBars["Tab Bar"]
        // Opent editView
        app.buttons["client"].tap()

        // change the client name
        app.textFields["client"].tap()

        app.textFields["client"].typeText("2")
        app.buttons["Return"].tap()

        // Is the new name visible in the clients list
        app.buttons["Home"].tap()
        tabBar.buttons["Clients"].tap()
        XCTAssertTrue(app.textFields["client2"].exists, "The new client name should be visible in the list.")
    }

    func testDeleteClient() {
        testCreateClient()
        // Opent editView
        app.buttons["client"].tap()
        app.buttons["Delete"].tap()
        XCTAssert(app.alerts.element.waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.alerts["Delete the client?"].exists, "There should be an alert after clicking delete.")
        app.alerts.buttons["Delete the client"].tap()
        let tabBar = app.tabBars["Tab Bar"]

        // Open ClientsView
        tabBar.buttons["Clients"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no client list rows initially")

    }

    func testSwipeAndDeleteClient() {
        testCreateClient()

        app.buttons["client"].swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertEqual(app.tables.cells.count, 0, "There should be no client list rows initially")

    }
 
    func testCreateProject() {
        let tabBar = app.tabBars["Tab Bar"]

      //  testCreateTask()
        // Create a client
        let exp = expectation(description: "Test after 1 seconds")
           let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        testCreateClient()

        // Add a project
        tabBar.buttons["Projects"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no project list rows initially")
        app.buttons["Add a Project"].tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Project 1")
        app.buttons["Add"].tap()

        // If i don't tap "Add" I end up with 4 rows somehow
        tabBar.buttons["Projects"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")
    }

    /* Doesn't work
    func testAddAnHour() {
        let tabBar = app.tabBars["Tab Bar"]
        // Create a client
        testCreateProject()

        tabBar.buttons["Home"].tap()
        testCreateTask()
        tabBar.buttons["Projects"].tap()

    }
     */
    
    
    func testTimeTrack() {
        let tabBar = app.tabBars["Tab Bar"]
        testCreateProject()
        tabBar.buttons["Time Tracker"].tap()
        let clientPicker = app.buttons["clientPicker"]
        let projectPicker = app.buttons["projectPicker"]
        XCTAssert(clientPicker.exists)
        XCTAssertEqual(clientPicker.value as! String, "client")
        XCTAssert(projectPicker.exists)
        XCTAssertEqual(projectPicker.value as! String, "Project 1")
    }

}
