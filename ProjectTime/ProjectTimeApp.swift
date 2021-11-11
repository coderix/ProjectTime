//
//  ProjectTimeApp.swift
//  Shared
//
//  Created by Dirk Newmann on 01.07.21.
//

import SwiftUI

@main
struct ProjectTimeApp: App {
    @StateObject var dataController: DataController

    init() {
            let dataController = DataController()
            _dataController = StateObject(wrappedValue: dataController)
        }

    func save(_ note: Notification) {
            dataController.save()
        }

    var body: some Scene {
            WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                       .environmentObject(dataController)
                    // Automatically save when we detect that we are
                    // no longer the foreground app. Use this rather than
                    // scene phase so we can port to macOS, where scene
                    // phase won't detect our app losing focus.
              //      .onReceive(NotificationCenter.default.publisher(
              //                  for: UIApplication.willResignActiveNotification), perform: save)
            }
        }
}
