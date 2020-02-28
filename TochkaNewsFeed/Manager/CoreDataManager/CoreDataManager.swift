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
        
        description.type = PersistenStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
    
    func saveViewContext() {
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
    
    func saveAsync<T: Populatable>(_ type: T.Type, populateFrom objects: [T.TSource], completion: (() -> Void)? = nil) {
        container.performBackgroundTask { privateContext in
            for object in objects {
                let entity = type.init(context: privateContext)
                entity.populateFrom(object: object)
            }
            do {
                try privateContext.save()
                completion?()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func fetchedResultsController<T: NSManagedObject>(with request: NSFetchRequest<T>) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController<T>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
}
