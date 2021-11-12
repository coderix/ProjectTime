//
//  ProjectHoursView.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 26.07.21.
//

import SwiftUI

struct ProjectHoursView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var project: Project
    @State private var showingAddScreen = false
    @State private var showingEditScreen = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: false)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    @State private var selectedHour: Hour?
    
    private func deleteHours1(offsets: IndexSet) {
        withAnimation {
            offsets.map { project.projectHours[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nsError = error as NSError
                
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    /*
     Her we get an Error: https://stackoverflow.com/questions/65080970/swiftui-coredata-simultaneous-accesses-to-0x7f92efc61cb8-but-modification-requ //swiftlint:disable:this line_length
     
     
     private func deleteHours(offsets: IndexSet) {
     
     let hours = project.projectHours
     for index in offsets {
     let h = hours[index]
     PersistenceController.shared.delete(h)
     
     }
     PersistenceController.shared.save()
     }
     */
    
    private func deleteHours(offsets: IndexSet) {
        let hours = project.projectHours
        viewContext.perform {
            offsets.map { hours[$0]}.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                //  userMessage = "\(error): \(error.localizedDescription)"
                //  displayMessage.toggle()
            }
        }
        
    }
    
    func cancel() {
        //  presentationMode.wrappedValue.dismiss()
    }
    private func add() {
        showingAddScreen.toggle()
    }
    
    var body: some View {
        
        VStack {
            Text("Project Times")
                .padding(.top)
            HStack {
                EditButton()
                Spacer()
                Button(action: add) {
                    Text("New Time")
                }
                .disabled(tasks.count == 0)
            }
            .padding()
            
            HStack {
                Text("Total: ")
                Text(project.projectDurationString)
                Text("Salary:")
                Text(project.projectSalaryString)
                Spacer()
            }
            .padding(.leading, 15.0)
            List {
                ForEach(project.projectHours) { hour in
                    
                    HStack {
                        Text(hour.formattedStartDay)
                            .font(.footnote)
                            .frame(width: 70, height: 30, alignment: .leading)
                        // .border(Color.red)
                        
                        Text(hour.formattedStartTime)
                            .font(.footnote)
                            .frame(width: 50, height: 30, alignment: .leading)
                        //  .border(Color.red)
                        
                        Text("-")
                            .font(.footnote)
                            .frame(width: 10, height: 30)
                        Text(hour.formattedEndTime)
                            .font(.footnote)
                            .frame(width: 50, height: 30, alignment: .leading)
                        //   .border(Color.red)
                        Text(hour.task?.taskTitle ?? "")
                            .font(.footnote)
                            .frame(width: 90, height: 30, alignment: .leading)
                        
                    }
                    .onTapGesture {
                        self.selectedHour = hour
                    }
                }
                .onDelete(perform: deleteHours)
                
            }
            /*
             There is a bug when you add an hour: the newly created hour and sometimes some more hours cannot be edited immidiately after adding. So I decided to close the whole project list: onDismiss: cancel // swiftlint:disable:this line_length
             */
            .sheet(isPresented: $showingAddScreen, onDismiss: cancel) {
                AddHourView(project: project).environment(\.managedObjectContext, self.viewContext)
                
            }
            .sheet(item: self.$selectedHour) { hour in
                NavigationView {
                    EditHour(hour: hour).environment(\.managedObjectContext, self.viewContext)
                }
            }
            .sheet(isPresented: $showingEditScreen) {
                EditProjectView(project: project)
                    .environment(\.managedObjectContext, viewContext)
            }
            
            .navigationTitle(Text(project.projectTitle))
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationBarItems(trailing: Button {
                self.showingEditScreen.toggle()
            } label: {
                Text("Edit")
            })
        }
    }
    
}

struct ProjectHoursView_Previews: PreviewProvider {
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
        project.details = "Project information"
        project.rate = 76.50
        project.timestamp = Date()
        project.client = client
        
        let task = Task(context: viewContext)
        task.id = UUID()
        task.title = "Example Task"
        
        let hour = Hour(context: viewContext)
        hour.id = UUID()
        hour.start = Date()
        var dateComponents = DateComponents()
        dateComponents.hour = 1
        hour.end = Calendar.current.date(byAdding: dateComponents, to: hour.start ?? Date())
        hour.details = "Besonderheiten dieser Aufgabe"
        hour.running = false
        hour.project = project
        hour.task = task
        
        return ProjectHoursView(project: project)
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
   
}
