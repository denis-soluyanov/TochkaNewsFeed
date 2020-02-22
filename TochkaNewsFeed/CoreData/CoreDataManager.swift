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
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAll<Object: NSManagedObject>(_: Object.Type, predicate: NSPredicate? = nil) -> [Object]? {
        let entityName = String(describing: Object.self)
        let fetchRequest = NSFetchRequest<Object>(entityName: entityName)
        
        fetchRequest.predicate = predicate
        
        var result: [Object]?
        
        do {
            result = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return result
    }
}
