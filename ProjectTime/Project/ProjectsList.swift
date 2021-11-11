//
//  ProjectsList.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 08.07.21.
//

import SwiftUI

struct ProjectsList: View {
    @Environment(\.managedObjectContext) private var viewContext

    var fetchRequest: FetchRequest<Project>
    // var showAllProjects = true

    init (client: Client) {
        fetchRequest = FetchRequest<Project>(entity: Project.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)],
                predicate: NSPredicate(format: "client == %@", client))
    }

    init () {
        fetchRequest = FetchRequest<Project>(entity: Project.entity(),
                        sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)])
    }

    private func deleteProjects(offsets: IndexSet) {
        withAnimation {
            offsets.map { fetchRequest.wrappedValue[$0] }.forEach(viewContext.delete)

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
        List {

            ForEach(fetchRequest.wrappedValue) { project in
                NavigationLink(
                    destination: ProjectHoursView(project: project)) {
                    HStack {
                        Text(project.projectTitle)
                        Spacer()
                        Text(project.clientName)
                    }
                }

            }
            .onDelete(perform: deleteProjects)

        }
        .listStyle(InsetGroupedListStyle())

    }
}

struct ProjectsList_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectsList()
            .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(dataController)
    }
}
