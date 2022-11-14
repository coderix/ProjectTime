//
//  Exporter.swift
//  ProjectTime
//
//  Created by Dirk on 14.11.22.
//

import Foundation
struct Exporter {
    
     func export(project: Project)-> ExportDocument {
        var csvString = "\("Date"),\("Task"),\("From"),\("To"),\("Time")\n\n"
        for hour in project.projectHours {
            csvString.append("\(hour.formattedStartDay),\(hour.task!.taskTitle),\(hour.formattedStartTime),\(hour.formattedEndTime),\(hour.durationString)\n")
        }
        csvString.append("Total Time: \(project.projectDurationString), Invoice: \(project.projectSalaryString)")
        //print (csvString)
        return ExportDocument(message: csvString)
        
        
        
    }
}
