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

    @State private var name: String

    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false
    @State private var showingProjectsList = false

    init(client: Client) {

        self.client = client

        _name = State(wrappedValue: client.clientName)

    }

    func update() {
        client.name = name
        client.timestamp = Date()

    }

    func delete() {
        dataController.delete(client)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        VStack {

            Form {
                Section(header: Text("Name")) {
                    TextField("Client name", text: $name)
                        .accessibilityIdentifier("clientsname")

                }
            }
            .frame(height: 100)
           // .padding(0)

            .onDisappear(perform: dataController.save)
            .navigationTitle("client bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingDeleteConfirm.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
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
            .onChange(of: name) { _ in update() }

            NavigationLink(destination: ProjectsView(), isActive: $showingProjectsList) { EmptyView() }
            Button("To the projects") {
                                showingProjectsList = true
                            }
            Spacer()

        //    Text("projects")

         //   ProjectsList(client: client)

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
