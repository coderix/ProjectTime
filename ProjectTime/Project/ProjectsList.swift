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
    @State private var selectedProject : Project?
    @State private var selectedProjectForHoursList : Project?
    @State private var showDeleteDialog = false
    @State private var showClient = true
    @State private var selectedAction : String? = nil
    
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
        withAnimation {
            offsets.map { fetchRequest.wrappedValue[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nsError = error as NSError
                
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    @State private var projectToDelete : Project?
    
    private func deleteProject() {
        if let p = projectToDelete {
            dataController.delete(p)
            dataController.save()
        }
    }
    
    var body: some View {
        List {
            
            ForEach(fetchRequest.wrappedValue) { project in
                HStack {
                    Text(project.projectTitle)
                 
                        .frame(maxWidth: .infinity, alignment: .leading)
                       
                    HStack{
                        NavigationLink(destination: ProjectHoursView(project: project), tag: "hours", selection: $selectedAction) {
                            Button{
                                selectedAction = "hours"
                            }
                        label: {
                            Image(systemName: "stopwatch")
                        }
                            .buttonStyle(.borderless)
                        }
                        NavigationLink(destination: EditProjectView(project: project), tag: "edit", selection: $selectedAction) {
                            Button {
                                selectedAction = "edit"
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                            .accessibilityHint("Edit")
                        }
                        Button {
                            self.projectToDelete = project
                            showDeleteDialog = true
                        } label: {
                           // Text("delete")
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        .buttonStyle(.borderless)
                    }
               
                }
               
                
            }
            
           
            
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
