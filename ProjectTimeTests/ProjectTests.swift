//
//  ProjectTests.swift
//  ProjectTimeTests
//
//  Created by Dirk Newmann on 20.09.21.
//

import XCTest
import CoreData
@testable import ProjectTime

class ProjectTests: BaseTestCase {

    func testCreatingClient() {
        let targetCountClient = 1
        let targetCountProject = 2
            let client = Client(context: managedObjectContext)

        for _ in 0..<targetCountProject {
            let project = Project(context: managedObjectContext)
            project.client = client
        }

        XCTAssertEqual(dataController.count(for: Client.fetchRequest()), targetCountClient)
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCountProject)
    }

    func testDeletingProjectCascadeDeletesHours() throws {
        try dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Client.fetchRequest()), 3)
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 6)
        XCTAssertEqual(dataController.count(for: Hour.fetchRequest()), 18)
        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)
        dataController.delete(projects[0])

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5)
        XCTAssertEqual(dataController.count(for: Hour.fetchRequest()), 15)
    }

}
