//
//  Extensions.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import CoreData

extension UserEntity {
    static func update(_ entity: UserEntity, _ model: UserData) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.email, forKey: "email")
        entity.setValue(model.firstName, forKey: "firstName")
        entity.setValue(model.lastName, forKey: "lastName")
        entity.setValue(model.avatar, forKey: "avatar")
    }
    
    @discardableResult
    static func fromApiModel(_ model: UserData, context: NSManagedObjectContext) -> UserEntity {
        let entity = UserEntity(context: context)

        update(entity, model)
        
        return entity
    }
    
    
    
    func toApiModel() -> UserData {
        let model = UserData(id: self.id ,
                         email: self.email ?? "",
                         firstName: self.firstName ?? "",
                         lastName: self.lastName ?? "",
                         avatar: self.avatar ?? "")
        
        return model
    }
}

extension PostEntity {
    static func update(_ entity: PostEntity, _ model: Post) {
        entity.setValue(model.id, forKey: "id")
        entity.setValue(model.name, forKey: "name")
        entity.setValue(model.year, forKey: "year")
        entity.setValue(model.color, forKey: "color")
        entity.setValue(model.pantoneValue, forKey: "pantoneValue")
    }
    
    @discardableResult
    static func fromApiModel(_ model: Post, context: NSManagedObjectContext) -> PostEntity {
        let entity = PostEntity(context: context)
        
        update(entity, model)
        
        return entity
    }
    
    func toApiModel() -> Post {
        let model = Post(id: self.id ,
                         name: self.name ?? "",
                         year: self.year ,
                         color: self.color ?? "",
                         pantoneValue: self.pantoneValue ?? "")
        
        return model
    }
}
