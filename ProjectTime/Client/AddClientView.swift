//
//  AddClientView.swift
//  clientTime
//
//  Created by Dirk Neumann on 14.03.22.
//

import SwiftUI
import CoreData

struct AddClientView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)],
        animation: .default)
    private var clients: FetchedResults<Client>

    @State private var timestamp = Date()
    @State private var rate = 0.0
    @State private var id = UUID()// swiftlint:disable:this identifier_name
    @State private var name = ""
    
    func save() {
        let client = Client(context: viewContext)
        client.name = name
        client.rate = 0.0
        client.id = UUID()
        dataController.save()
        
        presentationMode.wrappedValue.dismiss()
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

    var body: some View {
        NavigationView {
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
                                        .padding()
                    
                    }
                    
                    
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem {
                    Button("Add") {
                        save()
                    }
                    .disabled(nameNotValid)
                    .accessibilityIdentifier("Add")
                    
                }
            }
            .navigationTitle("New Client")
            .navigationBarTitleDisplayMode(.inline)
            
        
        }
    }
}

struct AddClientView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        AddClientView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
