//
//  AddProjectView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 25.06.21.
//

import SwiftUI
import CoreData

struct AddProjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest var clients: FetchedResults<Client>
    
    @State private var selection: Client?
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var closed = false
    @State private var timestamp = Date()
    @State private var rate = 0.0
    @State private var id = UUID()// swiftlint:disable:this identifier_name
    
    @State private var firstRun = true
    
    
    init (){
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Client.name, ascending: true)
        ]
        //   clientRequest.fetchLimit = 1
        self._clients = FetchRequest(fetchRequest: fetchRequest)
       // _selection = State(initialValue: clients.first!)
       
    }
    
    
    func save() {
        let project = Project(context: viewContext)
        project.title = title
        project.details = details
        project.timestamp = Date()
        project.closed = false
        project.rate = 0.0
        project.client = selection
        project.id = UUID()
        dataController.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }
    var body: some View {
        NavigationView {
            
            VStack {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Title", text: $title)
                    }
                    
                    Section(header: Text("Client")) {
                        Picker("client", selection: $selection) {
                            ForEach(clients) { (client: Client) in
                                Text(client.clientName).tag(client as Client?)
                            }
                        }
                        //  .pickerStyle(MenuPickerStyle())
                        
                    }
                    Section(header: Text("Details")) {
                        TextEditor(text: $details)
                    }
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        cancel()
                    }
                }
                ToolbarItem {
                    Button("Add") {
                        save()
                    }
                    
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            /*
             .onAppear {
             
             if firstRun {
             selection = clients.first!
             firstRun.toggle()
             }
             
             }
             */
        }
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        
        // return
        AddProjectView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        
    }
}
