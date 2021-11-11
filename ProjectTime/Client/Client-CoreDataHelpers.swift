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

   /* var clientProjects: [Project] {
        let projectsArray = projects?.allObjects as? [Project] ?? []
        
        return projectsArray.sorted { first, second in
            
            return first.projectTitle > second.projectTitle
        }
    }*/

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
