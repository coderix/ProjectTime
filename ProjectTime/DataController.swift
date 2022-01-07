import CoreData
import SwiftUI

class DataController: ObservableObject {
   // static let shared = Datacontroller()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
      //  container = NSPersistentCloudKitContainer(name: "Main")
        container = NSPersistentCloudKitContainer(name: "ProjectTime", managedObjectModel: Self.model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use
                // this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions
                 //or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        self.container.viewContext.automaticallyMergesChangesFromParent = true
        
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            self.deleteAll()
       //     UIView.setAnimationsEnabled(false)
        }
        #endif
    }

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "ProjectTime", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    static var preview: DataController = {
            let dataController = DataController(inMemory: true)
            let viewContext = dataController.container.viewContext

            do {
                try dataController.createSampleData()
            } catch {
                fatalError("Fatal error creating preview: \(error.localizedDescription)")
            }

            return dataController
        }()

    func save() {
        let context = container.viewContext

        /*
         if context.hasChanges {
         do {
         try context.save()
         } catch {
         let nsError = error as NSError
         fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
         }*/
        if context.hasChanges {
            try? context.save()
        }
    }
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    /// Get the current running hour
    /// - Returns: running hour or nil
    func getRunningHour () -> Hour? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Hour> = Hour.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Hour.id, ascending: true)
        ]
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "running = true")
      
        return try? context.fetch(fetchRequest).first
       
    }
     
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Hour.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)

        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
        _ = try? container.viewContext.execute(batchDeleteRequest3)

        let fetchRequest4: NSFetchRequest<NSFetchRequestResult> = Client.fetchRequest()
        let batchDeleteRequest4 = NSBatchDeleteRequest(fetchRequest: fetchRequest4)
        _ = try? container.viewContext.execute(batchDeleteRequest4)

    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
            (try? container.viewContext.count(for: fetchRequest)) ?? 0
        }

    func createSampleData() throws {

        let viewContext = container.viewContext

        let task1 = Task(context: viewContext)

        task1.title = "documentation"

        task1.id = UUID()

        let task2 = Task(context: viewContext)

        task2.title = "Ganz lange Development"

        task2.id = UUID()

        for clientCounter in 1...3 {

            let client = Client(context: viewContext)

            client.id = UUID()

            client.name = "client \(clientCounter)"

            client.projects = []

            client.timestamp = Date()

            for projectCounter in 1...2 {
                let project = Project(context: viewContext)

                project.id = UUID()

                project.title = "project \(projectCounter)"

                project.timestamp = Date()

                project.closed = false
                project.rate = 75.00

                project.client = client

                for hourCounter in 1...2 {

                    let hour = Hour(context: viewContext)

                    hour.project = project

                    hour.details = "Example hour \(hourCounter)"

                    hour.id = UUID()

                    hour.start = Date()

                    hour.end = Date()
                    hour.details = "DDDDDD"

                    hour.task = task1

                }

                let hour = Hour(context: viewContext)
                hour.project = project

                hour.details = "Example hour"

                hour.id = UUID()

                hour.start = Date().addingTimeInterval(600000)

                hour.end = hour.start?.addingTimeInterval(6000)

                hour.task = task2

            }

        }

        try viewContext.save()

    }

}
