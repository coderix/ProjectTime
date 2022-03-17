//
//  EditClientView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 19.05.21.
//

import SwiftUI

struct EditClientView: View {
    let client: Client
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)],
        animation: .default)
    private var clients: FetchedResults<Client>
    
    @State private var name: String
    @State private var timestamp: Date
    @State private var rate: Decimal
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false
    @State private var showingProjectsList = false
    
    init(client: Client) {
        
        self.client = client
        
        _name = State(wrappedValue: client.clientName)
        _timestamp = State(wrappedValue: client.clientTimestamp)
        _rate = State(wrappedValue: client.rate! as Decimal)
        
    }
    
    var nameNotValid: Bool {
        if name.isEmpty {
            return true
        }
        if clients.contains(where: {$0.name == name}) {
            return true
        }
        return false
    }
    
    func update() {
        client.name = name
        client.timestamp = Date()
        client.rate = (rate) as NSDecimalNumber
        dataController.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    func delete() {
        dataController.delete(client)
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
       // NavigationView {
            
            VStack {
                
                Form {
                    Section(header: Text("Client")) {
                        VStack {
                            TextField("Name", text: $name)
                                .accessibilityIdentifier("clientName")
                        }
                       
                    }
                    Section(header: Text("Rate")) {
                        TextField("Project Rate", value: $rate, format: .number)
                                       // .textFieldStyle(.roundedBorder)
                                        .keyboardType(.decimalPad)
                    }
                    Button(role: .destructive) {
                        showingDeleteConfirm.toggle()
                    } label: {
                        Label("Delete the client", systemImage: "trash")
                    }
                    
                    
                    
                }
                
                Text("Projects")
                    //.padding()
                ProjectsList(client: client)
                
              //  .onDisappear(perform: dataController.save)
                .navigationTitle("Edit client")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem {
                        Button("OK") {
                            update()
                        }

                    }
                }
                
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(title: Text("Delete the client?"),
                          message: Text("Deleting the client also deletes all projects belonging to the client"), // swiftlint:disable:this line_length
                          primaryButton: .default(Text("Delete the client"),
                                                  action: delete),
                          secondaryButton: .cancel())
                }
              //  .onChange(of: name) { _ in update() }
                
               
            }
        
    }
}

struct EditClientView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        let client = Client(context: dataController.container.viewContext)
        client.id = UUID()
        client.timestamp = Date()
        client.name = "Example Client"
        
        let project = Project(context: dataController.container.viewContext)
        project.id = UUID()
        project.title = "Example Project"
        project.details = "details"
        project.rate = 76.50
        project.timestamp = Date()
        project.client = client
        return NavigationView {
            EditClientView(client: client)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
            
        }
        
    }
}
