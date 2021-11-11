//
//  EditTaskView.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 24.07.21.
//

import SwiftUI

struct EditTaskView: View {

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    let task: Task

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Task>

    @State private var title: String
    @State private var showingDeleteConfirm = false

    var titleNotValid: Bool {
        if title.isEmpty {
            return true
        }
        if tasks.contains(where: {$0.title == title}) {
            return true
        }
        return false
    }

    var deletingNotAllowed: Bool {
        if task.hours?.count != 0 {
            return true
        }

        return false
    }

    init(task: Task) {
        self.task = task
        _title = State(wrappedValue: task.taskTitle)

    }

    func update() {

        task.title = title
    }

    func save() {
        task.title = title
        dataController.save()
        presentationMode.wrappedValue.dismiss()
    }

    func delete() {
        dataController.delete(task)
        dataController.save()
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {

        VStack {

            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }

                Button {
                    showingDeleteConfirm.toggle()
                } label: {Text("Delete this Task")}

                .disabled(deletingNotAllowed)

            }

        }

        .navigationTitle(task.taskTitle)
        .navigationBarTitleDisplayMode(.inline)
        //  .onDisappear(perform: PersistenceController.shared.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete the Task ?"),
                  message: Text(""),
                  primaryButton: .default(Text("Delete"),
                                          action: delete),
                  secondaryButton: .cancel())
        }
        .toolbar {

            ToolbarItem(placement: .navigationBarTrailing) {

                Button(action: save) {
                    Text("Done")
                }
                .disabled(titleNotValid)

            }
        }
        //  .onChange(of: title) { _ in update() }

    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        let task = Task(context: dataController.container.viewContext)
        task.id = UUID()
        task.title = "Example Task"
        return NavigationView {
            EditTaskView(task: task)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)

        }
    }
}

