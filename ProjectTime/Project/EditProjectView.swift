//
//  EditProjectView.swift
//  ProjectHours
//
//  Created by Dirk Newmann on 26.05.21.
//

import SwiftUI
import CoreData

struct EditProjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataController: DataController
    
    @FetchRequest var projects: FetchedResults<Project>
    
    let project: Project
    
    @State private var title: String
    @State private var originalTitle: String
    @State private var details: String
    @State private var clientName: String
    @State private var rate: Decimal
    
    @State private var showingDeleteConfirm = false
    
    
    @State private var isExporting: Bool = false
    @State private var document: ExportDocument?
    @State private var now = ""
    
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _originalTitle = State(wrappedValue: project.projectTitle)
        _details = State(wrappedValue: project.projectDetails)
        _clientName = State(wrappedValue: project.clientName)
        _rate = State(wrappedValue: ((project.rate ?? 0.0) as Decimal))
        
        let projectFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]
        self._projects = FetchRequest(fetchRequest: projectFetchRequest)
        
        
    }
    
    func export() {
        var csvString = "\("Date"),\("Task"),\("From"),\("To"),\("Time")\n\n"
        for hour in project.projectHours {
            csvString.append("\(hour.formattedStartDay),\(hour.task!.taskTitle),\(hour.formattedStartTime),\(hour.formattedEndTime),\(hour.durationString)\n")
        }
        csvString.append("Total Time: \(project.projectDurationString), Invoice: \(project.projectSalaryString)")
        //print (csvString)
        self.document = ExportDocument(message: csvString)
        
        isExporting = true
        
    }
    func update() {
        //   project.client?.objectWillChange.send()
        project.title = title
        project.details = details
        project.rate = NSDecimalNumber(decimal: rate as Decimal)
        project.timestamp = Date()
        presentationMode.wrappedValue.dismiss()
        
    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
    
    func cancel() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var titleNotValid: Bool {
        if title.isEmpty {
            return true
        }
        if projects.contains(where: {$0.title == title}) {
            if title != originalTitle {
                return true
            }
            
        }
        return false
    }
    
    var body: some View {
        
            VStack {
                Text(project.clientName)
                
                Form {
                    Section(header: Text("Title")) {
                        TextField("Project Title", text: $title)
                    }
                    
                    Section(header: Text("Rate")) {
                        TextField("Project Rate", value: $rate, format: .number)
                        // .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        // .padding()
                    }
                    
                    Section(header: Text("Details")) {
                        TextEditor(text: $details)
                    }
                    
                    Button(action: {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .none
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        now = dateFormatter.string(from: Date())
                        export() }, label: {
                            Text("Export")
                        })
                    
                    Button("Delete this Project") {
                        showingDeleteConfirm.toggle()
                    }
                    
                }
                .fileExporter(isPresented: $isExporting, document: document, contentType: .commaSeparatedText, defaultFilename: "ProjectTimeExport-\(project.projectTitle)-\(now).csv") { result in
                    if case .success = result {
                        // Handle success
                    } else {
                        // Handle failure
                    }
                }
            }
            
            .navigationTitle(project.projectTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear(perform: dataController.save)
            .alert(isPresented: $showingDeleteConfirm) {
                Alert(title: Text("Delete the Project?"),
                      message: Text("All hours of the project will also be deleted"),
                      primaryButton: .default(Text("Delete"),
                                              action: delete), secondaryButton: .cancel())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        cancel()
                    }
                }
                ToolbarItem {
                    Button("Done") {
                        update()
                    }
                    .disabled(titleNotValid)
                    
                }
         
            //     .onChange(of: title) { _ in update() }
            //     .onChange(of: details) { _ in update() }
        }
        
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        let client = Client(context: dataController.container.viewContext)
        client.id = UUID()
        client.timestamp = Date()
        client.name = "Example Client"
        
        let project = Project(context: dataController.container.viewContext)
        project.id = UUID()
        project.title = "Example Project"
        project.details = "Details ..."
        project.rate = 76.50
        project.timestamp = Date()
        project.client = client
        
        return NavigationView {
            EditProjectView(project: project)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
        
    }
}
