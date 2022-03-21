//
//  EditHour.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 04.08.21.
//

import SwiftUI

struct EditHour: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    @State private var selection: Task = Task()

    let hour: Hour
    //  @ObservedObject var hour: Hour
    @State private var details: String = ""
    @State private var start = Date()
    @State private var end = Date()
    @State private var running = false

    @State private var firstRun = true
    @State private var taskTitle = ""

    private var tempDuration: String {
        return end.timeIntervalSince(start).hourMinute
    }

    init(hour: Hour) {
        self.hour = hour
        _start = State(wrappedValue: hour.hourStart)
        _end = State(wrappedValue: hour.hourEnd)
        _details = State(wrappedValue: hour.hourDetails)
        _running = State(wrappedValue: hour.running)
        _selection = State(wrappedValue: hour.task ?? Task())

    }

    var taskTitleNotValid: Bool {
        if taskTitle.isEmpty {
            return true
        }
        if tasks.contains(where: {$0.title == taskTitle}) {
            return true
        }
        return false
    }

    func save() {
        hour.project?.objectWillChange.send()
        hour.project?.timestamp = Date()
        hour.start = Date.dateWithZeroSeconds(date: start)
        hour.end = Date.dateWithZeroSeconds(date: end)

        hour.details = details
        hour.task = selection
        dataController.save()
        presentationMode.wrappedValue.dismiss()
    }

    private func stopNow() {
        end = Date()
        save()
    }
    
    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
    //    NavigationView {
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
                    Picker("task", selection: $selection) {
                        ForEach(tasks) { (item: Task) in
                            Text(item.taskTitle).tag(item.self)
                        }
                    }
                    Toggle(isOn: $running) {
                        Text("Running")
                    }
                    Section(header: Text("Time")) {
                        DatePicker("Start", selection: $start, in: ...end, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("End", selection: $end, in: start..., displayedComponents: [.date, .hourAndMinute])
                        Button("Stop now") {
                            withAnimation {
                                stopNow()
                            }
                        }
                        HStack {
                            Text("Duration:  \(tempDuration)")
                        }
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
                    Button("OK") {
                        save()
                    }

                }
            }
            .navigationBarTitle(Text(hour.project?.projectTitle ?? ""))
            .navigationBarTitleDisplayMode(.inline)
     //   }
    }
}

struct EditHour_Previews: PreviewProvider {
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
        project.details = "huagadaddmök hhlköhjäö jlkhlökhköljhlökj hjöih"
        project.rate = 76.50
        project.timestamp = Date()
        project.client = client

        let task = Task(context: viewContext)
        task.id = UUID()
        task.title = "Example Task"

        let hour = Hour(context: viewContext)
        hour.id = UUID()
        hour.start = Date()
        hour.end = Date()
        hour.details = ""
        hour.project = project
        hour.task = task

        return NavigationView {
            EditHour(hour: hour)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
