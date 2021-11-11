//
//  HomeView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 18.05.21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    static let tag: String? = "Home"

    var body: some View {
        NavigationView {
            VStack {
                Button("Insert Example Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }

                NavigationLink("Tasks", destination: TasksView())

                Spacer()

            }

            .navigationTitle("Home")
        }
    //    .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
