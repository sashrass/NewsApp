//
//  ContentStorageService.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation
import CoreData

class ContentStorageService {
    private let storageService = StorageService()
    
    private var context: NSManagedObjectContext {
        storageService.managedContext
    }
    
    func addContent(_ content: [ContentModel]) {
        createEntitiesFromContentModels(content)
        
        if context.hasChanges {
            try? context.save()
        }
    }
    
    func deleteContent(_ content: [ContentModel]) {
        let ids = content.map { $0.id }
        
        storageService.deleteEntities(ofType: ContentEntity.self,
                                      predicate: NSPredicate(format: "id in %@", ids))
    }
    
    func getContent() -> [ContentModel] {
        let entities = storageService.getEntities(ofType: ContentEntity.self)
            .sorted(by: {
                guard let firstDate = $0.additionToLocalDBDate,
                      let secondDate = $1.additionToLocalDBDate else {
                    return false
                }
                return firstDate > secondDate
            })
        
        let models = mapEntitiesToContentModels(entities)
        
        return models
    }
    
    private func createEntitiesFromContentModels(_ models: [ContentModel]) {
        models.forEach { model in
            let entity = ContentEntity(context: context)
            entity.id = model.id
            entity.contentDescription = model.description
            entity.author = model.author
            entity.imageURL = model.imageURL
            entity.contentDate = model.date
            entity.sourceURL = model.sourceURL
            entity.additionToLocalDBDate = Date()
        }
    }
    
    private func mapEntitiesToContentModels(_ entities: [ContentEntity]) -> [ContentModel] {
        let models = entities.compactMap { entity -> ContentModel? in
            guard let id = entity.id,
                  let description = entity.contentDescription,
                  let author = entity.author,
                  let date = entity.contentDate else {
                return nil
            }
            
            let model = ContentModel(id: id,
                                     description: description,
                                     author: author,
                                     imageURL: entity.imageURL,
                                     date: date,
                                     sourceURL: entity.sourceURL,
                                     isFavorite: true)
            
            return model
        }
        
        return models
    }
}
