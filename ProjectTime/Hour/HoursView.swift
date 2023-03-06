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
    @FetchRequest var lastClients: FetchedResults<Client>
    
    @State private var selectedClientProject: Project?
    
    @FetchRequest  var projects: FetchedResults<Project>
    @State private var selectedProject: Project?
    
    @FetchRequest  var clients: FetchedResults<Client>
    @State private var selectedClient: Client?
    
    @State private var firstRun = true
    
    
    
    init () {
        
        let lastClientFetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        lastClientFetchRequest.fetchLimit = 1
        lastClientFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Client.timestamp, ascending: false)]
        _lastClients = FetchRequest(fetchRequest: lastClientFetchRequest)
        
        let clientFetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        clientFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Client.name, ascending: true)]
        self._clients = FetchRequest(fetchRequest: clientFetchRequest)
        
        
        
        let projectFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
        self._projects = FetchRequest(fetchRequest: projectFetchRequest)
        
        
        
    }
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    List {
                            Picker("Client", selection: $selectedClient) {
                                ForEach(clients) { client in
                                    if client.projectsCount > 0 {
                                        Text("\(client.clientName)")
                                            .tag(client as Client?)
                                    }
                                   
                                }
                            }
                            .onChange(of: selectedClient) { _ in
                                if let selectedClient {
                                    selectedProject = selectedClient.clientProjects.first
                                    selectedClient.timestamp = Date()
                                    dataController.save()
                                }
                            }
                  
                        
                    }
                    
                    if let selectedClient {
                        if selectedClient.projectsCount > 0 {
                            Picker("Project", selection: $selectedProject) {
                                ForEach(selectedClient.clientProjects) { project in
                                    HStack {
                                        Text(project.projectTitle)
                                        
                                    }
                                    .tag(project as Project?)
                                }
                            }
                            .onChange(of: selectedProject) { _ in
                                if let selectedProject {
                                    selectedProject.timestamp = Date()
                                    dataController.save()
                                }
                            }
                        } //if selectedClient.projectsCount > 0
                    } //if let selectedClient
                    
                }
            }
            .frame(maxHeight: 200)
            .navigationTitle(Text("Project Times"))
            .navigationBarTitleDisplayMode(.inline)
            
            
            if let selectedProject {
                ProjectHoursView(project: selectedProject)
            }
            Spacer()
        }
        
        .onAppear {
            if firstRun == true {
                
                selectedClient = lastClients.first
                
                if let selectedClient {
                    selectedProject = selectedClient.clientProjects.first
                }
                firstRun = false
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
