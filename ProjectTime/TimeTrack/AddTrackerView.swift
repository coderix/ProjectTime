//
//  AddTrackerView.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 07.01.22.
//

import SwiftUI
import CoreData

struct AddTrackerView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var clients: FetchedResults<Client>
    
    @State private var selectedClient: Client?
    
    @State  private var selectedProject: Project?
    
    @State private var selectedTask : Task?
    
    @FetchRequest var tasks: FetchedResults<Task>
    
    @State private var firstRun = true
    
    init() {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Client.timestamp, ascending: false)
        ]
        self._clients = FetchRequest(fetchRequest: fetchRequest)
        
        let fetchRequestTasks: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequestTasks.sortDescriptors = [NSSortDescriptor(keyPath:\Task.title, ascending: true)]
        self._tasks = FetchRequest(fetchRequest: fetchRequestTasks)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Client", selection: $selectedClient) {
                            ForEach(clients) { (client: Client) in
                                Text(client.clientName).tag(client as Client?)
                            }
                        }
                        .onChange(of: selectedClient, perform: {(value) in
                            self.selectedProject = self.selectedClient?.clientProjects.first
                        })
                        
                        
                        if selectedClient != nil {
                            Picker("Project", selection: $selectedProject) {
                                ForEach(selectedClient!.clientProjects) { (project: Project) in
                                    Text(project.projectTitle).tag(project as Project?)
                                }
                            }
                        }
                        
                    }
                    Section(header: Text("Tasks")){
                        Picker("Task", selection: $selectedTask) {
                            ForEach(tasks) { (task: Task) in
                                Text(task.taskTitle).tag(task as Task?)
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle("Track your time")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if firstRun == true {
                self.selectedClient = clients.first
                self.selectedProject = self.selectedClient?.clientProjects.first
                firstRun = false
            }
            
        }
    }
}


struct AddTrackerView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        AddTrackerView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
