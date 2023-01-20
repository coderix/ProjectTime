//
//  HoursView.swift
//  ProjectTime
//
//  Created by Dirk on 30.11.22.
//

import SwiftUI
import CoreData

struct HoursView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    
    static let tag: String? = "hours"
    
    @FetchRequest  var projects: FetchedResults<Project>
    @State private var selectedProject: Project?
    @State private var firstRun = true
    
    init () {
        let projectFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
        self._projects = FetchRequest(fetchRequest: projectFetchRequest)
        
        
    }
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    
                    Section("Project") {
                        Picker("", selection: $selectedProject) {
                                ForEach(projects) { project in
                                    HStack {
                                        Text("\(project.clientName) - \(project.projectTitle)")
                                      }
                                    .tag(project as Project?)
                                }
                        }
                    }
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                }
                .frame(maxHeight: 100)
                
                
                
                if let selectedProject {
                    ProjectHoursView(project: selectedProject)
                }
                Spacer()
            }
            
            .onAppear {
                if firstRun == true {
                    selectedProject = projects.first ?? Project()
                    firstRun = false
                }
            }
            
        }
    }
}

struct HoursView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        HoursView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
