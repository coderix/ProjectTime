//
//  Acivity-CoreDataHelpers.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 21.05.21.
//

import Foundation
extension Task {

    var taskTitle: String {
        title ?? ""
    }

    static var example: Task {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let task = Task(context: viewContext)
        task.id = UUID()
        task.title = "Example Task"

        return task
    }

}
