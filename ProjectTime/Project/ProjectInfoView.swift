//
//  ProjectInfoView.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 02.07.21.
//  Currently not used

import SwiftUI
import Foundation

struct ProjectInfoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    let project: Project

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    var rateString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let formattedRate = formatter.string(from: NSDecimalNumber(decimal: project.projectRate)) ?? "0"
        return formattedRate
    }

    var body: some View {
        NavigationView {
            VStack {
                Text(project.clientName)
                HStack {
                    Text("Rate: ")
                    Text(rateString)
               //     TextField("Price", value: project.projectRate, formatter: currencyFormatter)
                   // Text(project.projectRate)
                }
            }
            .navigationBarTitle(Text(project.projectTitle))
            .navigationBarTitleDisplayMode( .inline)
        }
    }
}

/*
struct ProjectInfoView_Previews: PreviewProvider {

    static var viewContext = Datacontroller.preview.container.viewContext

    static var previews: some View {
        let client = Client(context: viewContext)
        client.id = UUID()
        client.timestamp = Date()
        client.name = "Example Client"

        let project = Project(context: viewContext)
        project.id = UUID()
        project.title = "Example Project"
        project.rate = 76.50
        project.timestamp = Date()
        project.client = client

        return NavigationView {
            ProjectInfoView(project: project)
                .environment(\.managedObjectContext, Datacontroller.preview.container.viewContext)
        }
    }
}
 */
