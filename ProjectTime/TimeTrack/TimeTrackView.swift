//
//  timeTrackView.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 22.12.21.
//

import SwiftUI

struct TimeTrackView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    static let tag: String? = "TimeTrack"
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)],
        animation: .default)
    private var clients: FetchedResults<Client>

    @State private var selectedClient: Client = Client()
    @State private var firstRun = true
    
    init() {
    //    _selectedClient = State(wrappedValue: clients.first ?? Client())
    }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Client:")
                    Picker("client", selection: $selectedClient) {
                        ForEach(clients) { (client: Client) in
                            Text(client.clientName).tag(client.self)
                        }
                    }
                }
              //  Text($selectedClient.wrappedValue.clientName)
            }
            .navigationTitle("Track your time")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {

                if firstRun {
                    selectedClient = clients.first!
                    firstRun.toggle()
                }
               

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
