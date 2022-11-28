//
//  ClientsView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 18.05.21.
//

import SwiftUI
import CoreData

struct ClientsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)],
        animation: .default)
    private var clients: FetchedResults<Client>
    @State private var showError = false
    static let tag: String? = "clients"
    
    @State var showingAddClientView = false
    @State private var showingDeleteConfirmation = false
    @State private var clientToDelete: Client?

    private func addClient() {
        withAnimation {
            let newClient = Client(context: viewContext)
            newClient.timestamp = Date()
            newClient.name = "client"
            newClient.id = UUID()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                showError.toggle()

            }
        }
    }

 
    private func deleteClients(offsets: IndexSet) {
        for index in offsets {
            clientToDelete = clients[index]
            showingDeleteConfirmation.toggle()
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if clients.count == 0 {
                    Text("No clients")
                        .foregroundColor(.secondary)
                //    SelectSomethingView()
                } else {
                   
                        List {
                        
                            ForEach(clients) { client in
                                NavigationLink(
                                    destination: EditClientView(client: client),
                                    // destination: EmptyView(),
                                    label: {
                                        Text(client.clientName)
                                    })
                            }
               
                            // too dangerous without an alert
                            .onDelete(perform: deleteClients)
               
                        .listStyle(InsetGroupedListStyle())
                    }
                }
            }

            .navigationTitle("clients")

            .toolbar {

                #if os(iOS)

                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add a Client") {
                        showingAddClientView.toggle()
                    }
                }

            }
            .sheet(isPresented: $showingAddClientView) {
                AddClientView().environment(\.managedObjectContext, self.viewContext)
            }
            .alert(isPresented: $showError, content: {
                Alert(title: Text("Error"),
                            message: Text("A client with that name already exists"),
                            dismissButton: .default(Text("Continue")) {

                })

            })
            
            .alert("Delete the client(s)?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    dataController.delete(clientToDelete!)
                    dataController.save()
                    
                }
                Button("Cancel", role: .cancel) {}
            }

           

        }
    }
}

struct ClientsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ClientsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
                           .environmentObject(dataController)

    }
}
