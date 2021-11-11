//
//  ContentView.swift
//  Shared
//
//  Created by Dirk Newmann on 01.07.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(HomeView.tag)

            ProjectsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Projects")
                }
                .tag(ProjectsView.tag)

            ClientsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Clients")
                        .accessibilityIdentifier("Clients")
                }
                .tag(ClientsView.tag)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(dataController)
    }
}
