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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)],
        animation: .default)
    private var clients: FetchedResults<Client>
    @State private var showError = false
    static let tag: String? = "clients"

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
        withAnimation {
            offsets.map { clients[$0] }.forEach(viewContext.delete)

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

    var body: some View {
        NavigationView {
            Group {
                if clients.count == 0 {
                    Text("No clients")
                        .foregroundColor(.secondary)
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
                       // .onDelete(perform: deleteClients)
                    }
                    .listStyle(InsetGroupedListStyle())
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
                    Button(action: addClient) {
                        Label("Add new client", systemImage: "plus")
                    }
                }

            }
            .alert(isPresented: $showError, content: {
                Alert(title: Text("Error"),
                            message: Text("A client with that name already exists"),
                            dismissButton: .default(Text("Continue")) {

                })

            })

            SelectSomethingView()

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
