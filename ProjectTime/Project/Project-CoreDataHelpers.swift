//
//  project-CoreDataHelpers.swift
//  UltimateSwift
//
//  Created by Dirk Newmann on 05.05.21.
//
import Foundation
extension Project {

    var projectTitle: String {
        title ?? "New project"
    }

    var projectDetails: String {
        details ?? ""
    }

    var projectTimestamp: Date {
        timestamp ?? Date()
    }

    var clientName: String {
        client?.clientName ?? ""
    }

    var projectRate: Decimal {
        (rate ?? 0) as Decimal
    }

    var projectHours: [Hour] {
       let hoursArray = hours?.allObjects as? [Hour] ?? []
     
        return hoursArray.sorted { first, second in

            return first.hourStart > second.hourStart
        }
    }
 
    var projectTitleWithoutBackslash : String {
        return projectTitle.replacingOccurrences(of:"\\", with: "-")
    }
  
    var projectDuration: Double {
        let hou = projectHours.reduce(0, {$0 + $1.duration})

        return hou
    }

    var projectSalary: Decimal {
        var salary: Decimal = 0.0
        if (projectHours.count > 0) && (projectRate > 0) {
           //  sum = projectDuration * Double(projectRate)
            salary = Decimal(projectDuration ) * (projectRate / 3600)
        }
        return salary
    }

    var projectSalaryString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let formattedSalary = formatter.string(from: NSDecimalNumber(decimal: projectSalary)) ?? "0"
        return formattedSalary
    }

    var projectDurationString: String {
        return projectDuration.hourMinute
    }

    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let client = Client(context: viewContext)
        client.id = UUID()
        client.timestamp = Date()
        client.name = "Example Client"

        let project1 = Project(context: viewContext)
        project1.id = UUID()
        project1.title = "Example Project"
        project1.details = "Details ..."
        project1.rate = 76.50
        project1.timestamp = Date()
        project1.client = client

        let task1 = Task(context: viewContext)
        task1.id = UUID()
        task1.title = "Documentation"
        let task2 = Task(context: viewContext)
        task2.id = UUID()
        task2.title = "Development"

        let hour1 = Hour(context: viewContext)
        hour1.id = UUID()
        hour1.start = Date()
        hour1.end = Date()
        hour1.details = "H1 Details"
        hour1.task = task1
        hour1.project = project1

        let hour2 = Hour(context: viewContext)
        hour2.id = UUID()
        hour2.start = Date()
        hour2.end = Date()
        hour2.details = "H2 Details"
        hour2.task = task2
        hour2.project = project1
        return project1
    }
}
