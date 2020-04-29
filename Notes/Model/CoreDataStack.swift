//
//  CoreDataStack.swift
//  Notes
//
//  Created by Igor Podolskiy on 30.04.2020.
//  Copyright © 2020 Igor Podolskiy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    static let instance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
         return self.persistentContainer.newBackgroundContext()
     }()
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getBackgroundContext() -> NSManagedObjectContext {
        return backgroundContext
    }
    
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

