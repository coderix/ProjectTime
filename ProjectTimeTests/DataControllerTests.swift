//
//  DataControllerTests.swift
//  ProjectTimeTests
//
//  Created by Dirk Neumann on 07.01.22.
//

import XCTest
import CoreData
@testable import ProjectTime

class DataControllerTests: BaseTestCase {

    func testRunningHour() {
        
        let client = Client(context: managedObjectContext)
        client.id = UUID()
        client.timestamp = Date()
        client.name = "Hugo"

        XCTAssertEqual(dataController.count(for: Client.fetchRequest()), 1)
        
        let project = Project(context: managedObjectContext)
        project.id = UUID()
        project.timestamp = Date()
        project.title = "P1"
        project.client = client
        
        let task = Task(context: managedObjectContext)
        task.id = UUID()
        task.timestamp = Date()
        task.title = "t1"
        
        let hour = Hour(context: managedObjectContext)
        hour.id = UUID()
        hour.start = Date()
        hour.end = Date()
        hour.running = false
        hour.task = task
        
        XCTAssertNil(dataController.getRunningHour())
        hour.running = true
        XCTAssertNotNil(dataController.getRunningHour())
       
      
    }

   
}
