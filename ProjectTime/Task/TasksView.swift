//
//  TasksView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 11.06.21.
//

import SwiftUI
import CoreData

struct TasksView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    static let tag: String? = "tasks"
    @State private var title = ""

    init() {

    }

    var titleNotValid: Bool {
        if title.isEmpty {
            return true
        }
        if tasks.contains(where: {$0.title == title}) {
            return true
        }
        return false
    }

    var body: some View {
        
        List {
            if tasks.isEmpty {
                Text("Bevor es losgeht, musst du zunächsts mindestens eine Aufgabe anlegen")
            }
            HStack {
                TextField("New Task", text: $title)
                Button {
                    withAnimation {
                        let task = Task(context: viewContext)
                        task.id = UUID()
                        task.title = title
                        task.timestamp = Date()
                        dataController.save()
                        title = ""
                    }
                } label: {
                    Text("Add this Task")
                }
                .disabled(titleNotValid)
            }

            ForEach(tasks) { task in
                NavigationLink(
                    destination: EditTaskView(task: task),
                    label: {
                        Text(task.taskTitle)
                    })
            }
            .onDelete { offsets in
                for offset in offsets {
                    let task = tasks[offset]
                    if task.hours?.count == 0 {
                        dataController.delete(task)

                    }
                }
                dataController.save()
            }

        }
        .listStyle(.grouped)
        .navigationTitle("tasks")
        .toolbar {

#if os(iOS)

            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }

#endif
        }

    }
}

struct TasksView_Previews: PreviewProvider {

    static var dataController = DataController.preview
    static var previews: some View {

        NavigationView {
            TasksView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
