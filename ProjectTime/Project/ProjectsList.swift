//
//  ProjectsList.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 08.07.21.
//

import SwiftUI

struct ProjectsList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    
    var fetchRequest: FetchRequest<Project>
    
    @State private var showingEditScreen = false
    @State private var selectedProjectForHoursList : Project? = nil
    @State private var selectedProjectForEditProject : Project? = nil
    
    @State var navigationViewHoursListIsActive: Bool = false
    @State var navigationViewEditProjectIsActive: Bool = false
    
    @State private var showDeleteDialog = false
    @State private var projectToDelete : Project?
    @State private var showClient = true
    
    init (client: Client) {
        fetchRequest = FetchRequest<Project>(entity: Project.entity(),
                                             sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)],
                                             predicate: NSPredicate(format: "client == %@", client))
        _showClient = State(wrappedValue: false)
    }
    
    init () {
        fetchRequest = FetchRequest<Project>(entity: Project.entity(),
                                             sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)])
    }
    
    private func deleteProjects(offsets: IndexSet) {
        for index in offsets {
            projectToDelete = fetchRequest.wrappedValue[index]
            showDeleteDialog = true
        }
    }
    
    private func deleteProject() {
        if let p = projectToDelete {
            dataController.delete(p)
            dataController.save()
        }
    }
    
    @State private var path = [String]()
    
    var body: some View {
     //   NavigationStack() {
            VStack {
                
                List {
                    ForEach(fetchRequest.wrappedValue) { project in
                        
                        HStack {
                            NavigationLink(project.projectTitle, value: project)
                            
                        }
                        
                        .navigationDestination(for: Project.self) { project in
                            EditProjectView(project: project)
                        }
                        
                    }
                    .onDelete(perform: deleteProjects)
                    
                }
                .listStyle(InsetGroupedListStyle())
                .alert("Delete a Project", isPresented: $showDeleteDialog) {
                    Button("OK") {
                        deleteProject()
                    }
                    Button("Cancel", role: .cancel){}
                } message: {
                    Text("Do you really want to delete the project?")
                }
            }
    //    }
    }
}

struct ProjectsList_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        NavigationView {
            ProjectsList()
        }
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
}
