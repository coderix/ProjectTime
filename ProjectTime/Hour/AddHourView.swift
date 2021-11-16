//
//  AddHourView.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 27.07.21.
//

import SwiftUI

struct AddHourView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

   /*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>
*/
    let tasks: FetchRequest<Task>
    @State private var selection: Task = Task()

    @State private var details: String = ""
    @State private var start = Date.dateWithZeroSeconds(date: Date())
    @State private var end = Date.dateWithZeroSeconds(date: Date())

    @State private var firstRun = true
    @State private var taskTitle = ""

    // private var tasks: [Task]
    @ObservedObject var project: Project

    init(project: Project) {
        self.project = project
    //    _selection = State(wrappedValue: tasks.first ?? Task())

        tasks = FetchRequest<Task>(entity: Task.entity(),
                     sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)])
  //      _selection = State(wrappedValue: tasks.first ?? Task())

    }

    var taskTitleNotValid: Bool {
        if taskTitle.isEmpty {
            return true
        }

        if tasks.wrappedValue.contains(where: {$0.title == taskTitle}) {
            return true
        }

        return false
    }
    private func save () {
        project.objectWillChange.send()
        let hour = Hour(context: viewContext)

        hour.id = UUID()
        hour.start = start
        hour.end = end
        hour.details = details
        hour.project = project
        hour.task = selection
        hour.running = false
        project.timestamp = Date()

        dataController.save()

        presentationMode.wrappedValue.dismiss()
    }

    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {

        NavigationView {
            VStack {
                Form {
                    HStack {
                        TextField("New task", text: $taskTitle)
                        Button(action: {
                            withAnimation {
                                let task = Task(context: viewContext)
                                task.id = UUID()
                                task.title = taskTitle
                                dataController.save()
                                taskTitle = ""
                                selection = task

                            }
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .disabled(taskTitleNotValid)
                    }
                    Picker("Task", selection: $selection) {
                        ForEach(tasks.wrappedValue) { (item: Task) in
                            Text(item.taskTitle).tag(item.self)
                        }
                    }
                    Section(header: Text("Time")) {
                        DatePicker("Start", selection: $start, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("End", selection: $end, in: start..., displayedComponents: [.date, .hourAndMinute])
                    }
                    Section(header: Text("Details")) {
                        TextEditor(text: $details)
                    }

                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        cancel()
                    }
                }
                ToolbarItem {
                    Button("Add") {
                        save()
                    }

                }
            }
            .navigationBarTitle(Text("\(project.projectTitle) - New Time"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if firstRun == true {
                    selection = tasks.wrappedValue.first ?? Task()
                    firstRun = false
                }
            }

        }
    }

    struct AddHourView_Previews: PreviewProvider {
        static var dataController = DataController.preview
        static var viewContext = dataController.container.viewContext

        static var previews: some View {
            let client = Client(context: viewContext)
            client.id = UUID()
            client.timestamp = Date()
            client.name = "Example Client"

            let project = Project(context: viewContext)
            project.id = UUID()
            project.title = "Example Project"
            project.details = "details ...."
            project.rate = 76.50
            project.timestamp = Date()
            project.client = client
            return AddHourView(project: project)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)

        }
    }

}
