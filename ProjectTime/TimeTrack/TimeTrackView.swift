//
//  timeTrackView.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 22.12.21.
//

import SwiftUI
import CoreData

struct TimeTrackView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    static let tag: String? = "TimeTrack"
    
    @FetchRequest var clients: FetchedResults<Client>
    
    @State private var selectedClient: Client?
    
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

struct timeTrackView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        TimeTrackView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
