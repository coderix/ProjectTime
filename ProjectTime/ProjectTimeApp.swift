//
//  ProjectTimeApp.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 11.11.21.
//

import SwiftUI

@main
struct ProjectTimeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
