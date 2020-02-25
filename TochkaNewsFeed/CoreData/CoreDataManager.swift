//
//  CoreDataManager.swift
//  TochkaNewsFeed
//
//  Created by den on 21.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TochkaNewsFeed")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            precondition( storeDescription.type == NSInMemoryStoreType )
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init() {}
    
    static let shared: CoreDataManager = {
        return CoreDataManager()
    }()
    
    func saveContext () {
        context.perform {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func save(_ block: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
    
    func fetchedResultsController<T: NSManagedObject>(with request: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController<T>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    func remove<T: NSManagedObject>(object: T) {
        context.perform {
            self.context.delete(object)
        }
        saveContext()
    }
    
    func removeAll<T: NSManagedObject>(_: T.Type) {
        let request = NSBatchDeleteRequest(fetchRequest: T.fetchRequest())
        
        context.perform {
            do {
                print("Deleting all entities from CoreData")
                try self.context.execute(request)
            } catch {
                print(error)
            }
        }
        saveContext()
    }
}
