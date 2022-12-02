//
//  ProjectsView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 04.06.21.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.timestamp, ascending: false)],
        animation: .default)
    private var projects: FetchedResults<Project>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Client.timestamp, ascending: false)],
        animation: .default)
    private var clients: FetchedResults<Client>

    static let tag: String? = "projects"

    @State var showingAddProjectView = false
    init() {

    }

    var projectAddingNotAllowed: Bool {
        if clients.count > 0 {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Group {
                if projects.count == 0 {
                    Text("No projects found")
                        .foregroundColor(.secondary)
                        .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                } else {
                    ExtractedView()
                }
            }
            .navigationBarTitle("Projects")
            
            .toolbar {

                #if os(iOS)
/*
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
 */
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add a Project") {
                        showingAddProjectView.toggle()
                    }
                    .disabled(projectAddingNotAllowed)
                }
                #endif
            }

            .sheet(isPresented: $showingAddProjectView) {
                AddProjectView().environment(\.managedObjectContext, self.viewContext)
            }

        //    SelectSomethingView()

        }

    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        NavigationView {
            ProjectsView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                            .environmentObject(dataController)
        }
    }
}

struct ExtractedView: View {
    var body: some View {
        ProjectsList()
    }
}
