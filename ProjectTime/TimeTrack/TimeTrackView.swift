//
//  timeTrackView.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 22.12.21.
//

import SwiftUI
import CoreData

struct TimeTrackView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    static let tag: String? = "TimeTrack"
    
    
    
    init() {
       
    }
    
    var body: some View {
       AddTrackerView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
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
