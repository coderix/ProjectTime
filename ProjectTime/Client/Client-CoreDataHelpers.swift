//
//  Client-CoreDataHelpers.swift
//  UltimateSwift
//
//  Created by Dirk Newmann on 05.05.21.
//

import Foundation

extension Client {
    var clientName: String {
        name ?? "New client"
    }

    var clientTimestamp: Date {
        timestamp ?? Date()
    }

    var projectsCount : Int {
        return projects?.allObjects.count ?? 0
    }
    var clientProjects: [Project] {
        let projectsArray = projects?.allObjects as? [Project] ?? []
        
        return projectsArray.sorted { first, second in
            
            return first.projectTimestamp > second.projectTimestamp
        }
    }

    static var example: Client {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let client = Client(context: viewContext)
        client.name = "Example Client"
        client.id = UUID()
        client.timestamp = Date()

        return client
    }

}
