//
//  FollowingDataService.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import CoreData

class FollowingDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "FollowingContainer"
    private let entityName: String = "FollowingEntity"
    
    var savedEntities: [FollowingEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getFollowing()
        }
    }
    
    func saveFollowing(user: User) {
        if let entity = savedEntities.first(where: { $0.id == user.id }) {
            if !user.isFollowing {
                delete(entity: entity)
            }
        } else {
            if user.isFollowing {
                add(user: user)
            }
        }
    }
    
    private func getFollowing() {
        let request = NSFetchRequest<FollowingEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        
        } catch let error {
            print("Error fetching Favorities Entities. \(error)")
        }
    }
    
    private func add(user: User) {
        let entity = FollowingEntity(context: container.viewContext)
        entity.id = Int32(user.id)
        applyChanges()
    }
    
    
    private func delete(entity: FollowingEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getFollowing()
    }
}
