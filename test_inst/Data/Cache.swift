//
//  Cache.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation
import CoreData

class PesrsistentContainer {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    func  getDisposableContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedContext
        
        return context
    }
}

extension NSManagedObjectContext {
    func trySaveContext() {
        print(" #### has changes \(self.hasChanges)")
        guard self.hasChanges else { return }
        do {
            try self.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}


class Cache {
    private var bacgroundQueue = DispatchQueue.global(qos: .background)
    let container: PesrsistentContainer
    
    init(container: PesrsistentContainer) {
        self.container = container
    }
    
    func storeEntity<T: NSManagedObject & ManagedObjectConvertible>(_ posts: [T.ApiModelType], entityType: T.Type) {
        bacgroundQueue.async {
            let context = self.container.getDisposableContext()
            let entities = posts.map {
                if let entity = self.findEntity(id: $0.id, entityType: T.self, context: context) {
                    T.update(entity, $0)
                    return entity
                } else {
                    return T.fromApiModel($0, context: context)
                }
            }
            
            print("### stored \(T.self) \(entities.count)")
            
            context.trySaveContext()
            DispatchQueue.main.async {
                self.container.managedContext.trySaveContext()
            }
        }
    }

    func findEntity<T: NSManagedObject>(id: Int32, entityType: T.Type, context: NSManagedObjectContext) -> T? {
        var entities: [T] = []
        do {
            let fetchRequest = T.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            entities = try context.fetch(fetchRequest).compactMap { $0 as? T }
        }
        catch let error {
            print(error)
        }
        
        return entities.first
    }
    
    private func fetchEntities<T: NSManagedObject & Identifiable>(context: NSManagedObjectContext) -> [T] {
        var entities: [T] = []
        do {
            let fetchRequest = T.fetchRequest()
            entities = try context.fetch(fetchRequest).compactMap { $0 as? T }
        }
        catch let error {
            print(error)
        }
        
        entities.sort { $0.id < $1.id }
        return entities
    }
    
    func fetchModels<T: NSManagedObject & Identifiable, Model>(entityType: T.Type) -> [Model] where T: ManagedObjectConvertible, Model == T.ApiModelType {
        let entities: [T] = fetchEntities(context: container.managedContext)
        return entities.map { $0.toApiModel() }
    }
}

