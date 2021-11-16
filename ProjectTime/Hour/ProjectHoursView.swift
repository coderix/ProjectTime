//
//  ProjectHoursView.swift
//  ProjectTime
//
//  Created by Dirk Newmann on 26.07.21.
//

import SwiftUI

struct ProjectHoursView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var project: Project
    @State private var showingAddScreen = false
    @State private var showingEditScreen = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.title, ascending: false)],
        animation: .default)
    private var tasks: FetchedResults<Task>
    
    @State private var selectedHour: Hour?
    
    private func deleteHours(offsets: IndexSet) {
        
        let hours = project.projectHours
        for index in offsets {
            let h = hours[index]
            dataController.delete(h)
        }
        dataController.save()
    }
     
    /*
    private func deleteHoursOld(offsets: IndexSet) {
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
    */
    
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
                Text("Invoice:")
                Text(project.projectSalaryString)
                Spacer()
            }
            .padding(.leading, 15.0)
            List{
                ForEach(project.projectHours) { hour in
                    
                    HStack {
                        VStack {
                            
                            HStack {
                                Text(hour.formattedStartDay)
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                
                                Text(hour.formattedStartTime)
                                    .font(.footnote)
                                
                                Text("-")
                                    .font(.footnote)
                                
                                Text(hour.formattedEndTime)
                                    .font(.footnote)
                                
                                Spacer()
                                Text(hour.durationString)
                                    .font(.footnote)
                            }
                            
                            HStack {
                                Text(hour.task?.taskTitle ?? "")
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                    .onTapGesture {
                        self.selectedHour = hour
                    }
                }
                .onDelete(perform: deleteHours)
                
            }
            .padding()
            .background(Color.systemGroupedBackground.ignoresSafeArea())
           
           
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
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
    
}
