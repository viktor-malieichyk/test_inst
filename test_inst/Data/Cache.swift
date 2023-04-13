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
    
    func storePosts(_ posts: [Post]) {
        bacgroundQueue.async {
            let context = self.container.getDisposableContext()
            let entities = posts.map{ PostEntity.fromApiModel($0, context: context) }
            
            print(entities.count)
            
            context.trySaveContext()
            DispatchQueue.main.async {
                self.container.managedContext.trySaveContext()
            }
        }
    }
    
    func storeUsers(_ users: [UserData]) {
        bacgroundQueue.async {
            let context = self.container.getDisposableContext()
            let entities = users.map{ UserEntity.fromApiModel($0, context: context) }
            
            print(entities.count)
            
            context.trySaveContext()
            DispatchQueue.main.async {
                self.container.managedContext.trySaveContext()
            }
        }
    }
    
    private func fetchPosts(context: NSManagedObjectContext) -> [PostEntity] {
        var entities: [PostEntity] = []
        do {
            let fetchRequest = PostEntity.fetchRequest()
            
            entities = try context.fetch(fetchRequest)
        }
        catch let error {
            print(error)
        }
        
        return entities
    }
    
    private func fetchUsers(context: NSManagedObjectContext) -> [UserEntity] {
        var entities: [UserEntity] = []
        do {
            let fetchRequest = UserEntity.fetchRequest()
            
            entities = try context.fetch(fetchRequest)
        }
        catch let error {
            print(error)
        }
        
        return entities
    }
    
    func fetchPostModels() -> [Post] {
        let entities = fetchPosts(context: container.managedContext)
        return entities.map { $0.toApiModel() }
    }
    
    func fetchUserModels() -> [UserData] {
        let entities = fetchUsers(context: container.managedContext)
        return entities.map { $0.toApiModel() }
    }
}

