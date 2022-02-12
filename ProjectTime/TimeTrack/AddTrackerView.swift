//
//  AddTrackerView.swift
//  ProjectTime
//
//  Created by Dirk Neumann on 07.01.22.
//

import SwiftUI
import CoreData

struct AddTrackerView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var clients: FetchedResults<Client>
    
    @State private var selectedClient: Client?
    
    @State  private var selectedProject: Project?
    
    @State private var selectedTask : Task?
    
    @State private var runningHour : Hour?
    
    @FetchRequest var tasks: FetchedResults<Task>
    
    @State private var firstRun = true
    
    init() {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Client.timestamp, ascending: false)
        ]
        self._clients = FetchRequest(fetchRequest: fetchRequest)
        
        let fetchRequestTasks: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequestTasks.sortDescriptors = [NSSortDescriptor(keyPath:\Task.title, ascending: true)]
        self._tasks = FetchRequest(fetchRequest: fetchRequestTasks)
    }
    
    var trackingNotValid: Bool {
        if (selectedClient == nil) || (selectedProject == nil) || (selectedTask == nil){
            return true
        } else {return false}
    }
   
    
   
    @State private var stopButtonNotValid = true
    @State private var editButtonNotValid = true
    @State private var deleteButtonNotValid = true
    @State private var startButtonNotValid = true
    
    func initializeForm() {
        print("onAppear")
        if let hour = dataController.getRunningHour() {
            
        } else {
            
        }
        if firstRun == true {
            print("firstRun")
            self.selectedClient = clients.first
            self.selectedProject = self.selectedClient?.clientProjects.first
            self.selectedTask = tasks.first
            self.stopButtonNotValid = true
            self.startButtonNotValid = false
            firstRun = false
        }
    }
    
    func startTracking() {
       
        selectedProject!.objectWillChange.send()
        let hour = Hour(context: viewContext)

        hour.id = UUID()
        hour.start = Date()
        hour.end = Date()
        hour.details = ""
        hour.project = selectedProject
        hour.task = selectedTask!
        hour.running = true
        selectedProject!.timestamp = Date()

        dataController.save()
        runningHour = hour
        stopButtonNotValid = false
    }
    
    func stopTracking() {
       
        print("stop")
        if runningHour != nil {
            runningHour!.end = Date()
            runningHour!.running = false
            selectedProject!.timestamp = Date()
            dataController.save()
            
        }
        stopButtonNotValid = true
        deleteButtonNotValid = false
        editButtonNotValid = false
        startButtonNotValid = false
        
    }
    
    func taskChanged(to value: Task){
        
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Picker("Client", selection: $selectedClient) {
                            ForEach(clients) { (client: Client) in
                                Text(client.clientName).tag(client as Client?)
                            }
                            .accessibility(identifier: "clientPicker")
                        }
                        .onChange(of: selectedClient, perform: {(value) in
                            self.selectedProject = self.selectedClient?.clientProjects.first
                        })
                        
                        
                        if selectedClient != nil {
                            Picker("Project", selection: $selectedProject) {
                                ForEach(selectedClient!.clientProjects) { (project: Project) in
                                    Text(project.projectTitle).tag(project as Project?)
                                }
                            }
                            .accessibility(identifier: "projectPicker")
                        }
                        
                    }
                    Section(header: Text("Select a task")){
                        HStack {
                            Picker("Task", selection: $selectedTask) {
                                ForEach(tasks) { (task: Task) in
                                    Text(task.taskTitle).tag(task as Task?)
                                }
                            }
                            
                           // onChange(of: selectedTask, perform: {value in startTracking(value)})
                        }
                    }
                    
                    Section(header: Text("Tracking")) {
                       
                            HStack {
                                
                                Button("Start"){
                                    startTracking()
                                }
                                // without the BorderlessButtonStyle all actions are fired
                                // when you tap somewhere in the hstack
                                .buttonStyle(BorderlessButtonStyle())
                                .disabled(startButtonNotValid)
                                 
                                Button("Stop"){
                                    stopTracking()
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .disabled(stopButtonNotValid)
                                
                                Button("Edit"){
                                    print("Edit Button")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .disabled(editButtonNotValid)
                                 
                            }
                           
                        
                   
                    }
                    
                    Section(header: Text("Running Task")){
                        if let hour = runningHour {
                            if hour.running {
                                HStack {
                                    Text(hour.task!.taskTitle)
                                    Text("activ since")
                                    Text (hour.formattedStartTime)
                                }
                            } else {
                                HStack {
                                    Text(hour.task!.taskTitle)
                                    Text(":")
                                    Text (hour.formattedStartTime)
                                    Text("-")
                                    Text (hour.formattedEndTime)
                                }
                            }
                            
                        } else {
                            Text("Currently no running task ")
                        }
                    }
                     
                }
            }
            .navigationTitle("Track your time")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: initializeForm)
       
    }
}


struct AddTrackerView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        AddTrackerView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
