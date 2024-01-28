//
//  StorageService.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation
import CoreData

class StorageService {
    
    lazy var managedContext: NSManagedObjectContext = {
        StorageService.persistentContainer.viewContext
    }()
    
    private static var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "NewsApp")
         container.loadPersistentStores { description, error in
              if let error = error {
                   fatalError("Unable to load persistent stores: \(error)")
              }
         }
         return container
    }()
    
    func getEntities<Entity: NSManagedObject>(ofType: Entity.Type) -> [Entity] {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        
        do {
            let entities = try managedContext.fetch(fetchRequest)
            return entities
        } catch {
            return []
        }
    }
    
    func deleteEntities<Entity: NSManagedObject>(ofType: Entity.Type, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        
        fetchRequest.predicate = predicate
        
        do {
            let entities = try managedContext.fetch(fetchRequest)
            
            entities.forEach { entity in
                managedContext.delete(entity)
            }
            
            if managedContext.hasChanges {
                try managedContext.save()
            }
        } catch {
            
        }
    }
}
