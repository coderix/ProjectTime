//
//  timeTrackView.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 22.12.21.
//

import SwiftUI

struct TimeTrackView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    static let tag: String? = "TimeTrack"
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct timeTrackView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        TimeTrackView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
