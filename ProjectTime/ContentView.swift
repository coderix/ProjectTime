//
//  ContentView.swift
//  Shared
//
//  Created by Dirk Newmann on 01.07.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @SceneStorage("selectedView") var selectedView: String?
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var clients: FetchedResults<Client>
    @FetchRequest var projects: FetchedResults<Project>
    
    
    init(){
        let clientRequest: NSFetchRequest<Client> = Client.fetchRequest()
        clientRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Client.name, ascending: true)
        ]
        clientRequest.fetchLimit = 1
        _clients = FetchRequest(fetchRequest: clientRequest)
        
        let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
        projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
        projectRequest.fetchLimit = 1
        _projects = FetchRequest(fetchRequest: projectRequest)
    }
    
    var show = true
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(HomeView.tag)
            
            if projects.count > 0 {
                
                
                TimeTrackView()
                    .tabItem {
                        Image(systemName: "stopwatch.fill")
                        Text("Time Tracker")
                    }
                    .tag(TimeTrackView.tag)
            }
            
            if clients.count > 0 {
                ProjectsView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Projects")
                    }
                    .tag(ProjectsView.tag)
            }
            
            ClientsView()
            
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Clients")
                        .accessibilityIdentifier("Clients")
                }
                .tag(ClientsView.tag)
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
