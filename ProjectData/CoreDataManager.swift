//
//  CoreDataManager.swift
//  ProjectData
//
//  Created by Igor Abovyan on 02.11.2021.
//

import CoreData

class CoreDataManager {
    
    static let shered = CoreDataManager.init()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ProjectData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

//MARK: Create
extension CoreDataManager {
    
    func createTask() -> Task {
        let context = persistentContainer.viewContext
        let task = Task.init(context: context)
        self.saveContext()
        return task
    }
}


extension CoreDataManager {
    
     func getAllTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<Task>.init(entityName: "Task")
        let sortDescriptor = NSSortDescriptor.init(key: #keyPath(Task.name), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = persistentContainer.viewContext
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        }catch {
            fatalError("error \(error)")
        }
        
    }
    
    func getFavorites() -> [Task] {
        let fetchRequest = NSFetchRequest<Task>.init(entityName: "Task")
        let sortDescriptor = NSSortDescriptor.init(key: #keyPath(Task.name), ascending: true)
        let predicate = NSPredicate.init(format: "isFavorites == true")
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        let context = persistentContainer.viewContext
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        }catch {
            fatalError("error \(error)")
        }
        
    }
    
}


