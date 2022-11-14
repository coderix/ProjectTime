//
//  EditProjectModel.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 11.11.22.
//

import Foundation
import SwiftUI
import CoreData

extension EditProjectView {

    @MainActor class EditProjectModel: ObservableObject {
        
     //   @Environment(\.presentationMode) var presentationMode
        
   //     @Environment(\.managedObjectContext) private var viewContext
        
        @EnvironmentObject var dataController: DataController
        
        @FetchRequest var projects: FetchedResults<Project>
        
        let project: Project
        
        @State private var title: String
        @State private var originalTitle: String
        @State private var details: String
        @State private var clientName: String
        @State private var rate: Decimal
        
        @State private var showingDeleteConfirm = false
        
        
        @State private var isExporting: Bool = false
        @State private var document: ExportDocument?
        @State private var now = ""
        
        init(project: Project) {
            self.project = project
            _title = State(wrappedValue: project.projectTitle)
            _originalTitle = State(wrappedValue: project.projectTitle)
            _details = State(wrappedValue: project.projectDetails)
            _clientName = State(wrappedValue: project.clientName)
            _rate = State(wrappedValue: ((project.rate ?? 0.0) as Decimal))
            
            let projectFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
            self._projects = FetchRequest(fetchRequest: projectFetchRequest)
            
            
        }
        
    }
}

