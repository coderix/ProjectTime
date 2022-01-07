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
    @State var selectedProject: Project?
    
    @State private var firstRun = true
    
    init() {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Client.name, ascending: true)
        ]
        self._clients = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("client", selection: $selectedClient) {
                            ForEach(clients) { (client: Client) in
                                Text(client.clientName).tag(client as Client?)
                            }
                        }
                        
                        if selectedClient != nil {
                            Picker("project", selection: $selectedProject) {
                                ForEach(selectedClient!.clientProjects) { (project: Project) in
                                    Text(project.projectTitle).tag(project as Project?)
                                }
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
