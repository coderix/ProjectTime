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

    func testAppHas3Tabs() throws {
        // UI tests must launch the application that they test.

        XCTAssertEqual(app.tabBars.buttons.count, 3, "There should be 4 tabs in the app")
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testCreateTask() {
        app.buttons["Home"].tap()
        app.buttons["Tasks"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows initially")

        // you must enter a title for the activity before you can create one
        app.buttons["Add this Task"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows initially")

        // create new activity with a title
        app.textFields["New Task"].tap()
        app.textFields["New Task"].typeText("Development")
        app.buttons["Add this Task"].tap()
        XCTAssertEqual(app.tables.cells.count, 3, "There should be 3 list rows after adding a project.")

    }
    func testCreateClient() {
        let tabBar = app.tabBars["Tab Bar"]

        // Open ClientsView
        tabBar.buttons["Clients"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 client list row initially")

        // create new client
        app.buttons["Add new client"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding a project.")

    }

    func testEditClient () throws{
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Clients"].tap()
        app/*@START_MENU_TOKEN@*/.tables/*[[".otherElements[\"Clients\"].tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["Example Client"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        let textField = app/*@START_MENU_TOKEN@*/.tables.textFields["clientName"]/*[[".otherElements[\"Clients\"].tables",".cells",".textFields[\"Client name\"]",".textFields[\"clientName\"]",".tables"],[[[-1,4,1],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/
        textField.tap()
        textField.typeText("2")
        app/*@START_MENU_TOKEN@*/.navigationBars["client bearbeiten"]/*[[".otherElements[\"Clients\"].navigationBars[\"client bearbeiten\"]",".navigationBars[\"client bearbeiten\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["clients"].tap()
        
        // Is the new name visible in the clients list
        app.buttons["Home"].tap()
        app.buttons["Clients"].tap()
        XCTAssertTrue(app/*@START_MENU_TOKEN@*/.tables/*[[".otherElements[\"Clients\"].tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["Example Client2"].exists, "The new client name should be visible in the list.")
      
        
    }
    

    func testDeleteClient() {
        
        // Opent editView
        app.tabBars["Tab Bar"].buttons["Clients"].tap()
        app/*@START_MENU_TOKEN@*/.tables/*[[".otherElements[\"Clients\"].tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["Example Client"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        
        app.buttons["Delete"].tap()
        XCTAssert(app.alerts.element.waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.alerts["Delete the client?"].exists, "There should be an alert after clicking delete.")
        app.alerts.buttons["Delete the client"].tap()
        let tabBar = app.tabBars["Tab Bar"]

        // Open ClientsView
        tabBar.buttons["Clients"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no client list rows initially")

    }

    /*
    func testSwipeAndDeleteClient() {
        testCreateClient()

        app.buttons["client"].swipeLeft()
        app.buttons["Delete"].tap()

        XCTAssertEqual(app.tables.cells.count, 0, "There should be no client list rows initially")

    }
     */
 
    func testCreateProject() {
        let tabBar = app.tabBars["Tab Bar"]
         // Add a project
        tabBar.buttons["Projects"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project list row initially")
        app.buttons["Add a Project"].tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Project 1")
        app.buttons["Add"].tap()

        // If i don't tap "Add" I end up with 4 rows somehow
        tabBar.buttons["Projects"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding a project.")
    }

    /*
    func testTimeTrack() {
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Time Tracker"].tap()
        let clientPicker = app.buttons["clientPicker"]
        let projectPicker = app.buttons["projectPicker"]
        let taskPicker = app.buttons["taskPicker"]
        let labelActive = app.staticTexts["labelActive"]
        XCTAssert(clientPicker.exists)
        XCTAssertEqual(clientPicker.value as! String, "Example Client")
        XCTAssert(projectPicker.exists)
        XCTAssertEqual(projectPicker.value as! String, "Example Project")
        XCTAssertEqual(taskPicker.value as! String, "Example Task", "Message")
        XCTAssertFalse(labelActive.exists,"Label should not be here")
        app.buttons["Start"].tap()
        XCTAssertTrue(labelActive.exists,"Label should be here")
        app.buttons["Stop"].tap()
        XCTAssertFalse(labelActive.exists,"Label should not be here")
    }
     */

}
