//
//  CoreDataManager.swift
//  TEA iOS Technical Task
//
//  Created by Mahmoud Ragab on 15/08/2025.
//

import CoreData
import Foundation

final class CoreDataManager: LocalDbManager {
    static let shared = CoreDataManager()

    private init() {
        persistentContainer = NSPersistentContainer(name: "TEA_iOS_Technical_Task")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
            
        }
    }

    private let persistentContainer: NSPersistentContainer

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func createEntity<T>(_: T.Type) -> T {
        if let entityType = T.self as? NSManagedObject.Type {
            guard let entity = entityType.init(context: context) as? T else {
                fatalError("Failed to initialize entity of type \(T.self)")
            }
            return entity
        } else {
            fatalError("T must conform to NSManagedObject")
        }
    }

    // Save Objects
    func saveObjects<T>(_ obj: [T]) {
        guard let managedObjects = obj as? [NSManagedObject] else { return }
        do {
            managedObjects.forEach { context.insert($0) }
            try context.save()
        } catch {
            print("Error saving objects: \(error)")
        }
    }

    // Get All Objects with Optional Predicate

    func getAllObjects<T>(_ type: T.Type, where query: String? = nil) -> [T] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        // Apply the optional query as an NSPredicate if provided
        if let query = query {
            fetchRequest.predicate = NSPredicate(format: query)
        }

        do {
            return try context.fetch(fetchRequest) as? [T] ?? []
        } catch {
            print("Error fetching objects: \(error)")
            return []
        }
    }

    // Delete Object
    func deleteObject<T>(_ predicate: NSPredicate, withType type: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        fetchRequest.predicate = predicate

        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject],
               let objectToDelete = results.first
            {
                context.delete(objectToDelete)
                try context.save()
            }
        } catch {
            print("Error deleting object: \(error)")
        }
    }

    // Delete Multiple Objects
    func deleteObjects<T>(data: [T]) {
        guard let managedObjects = data as? [NSManagedObject] else { return }
        do {
            managedObjects.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Error deleting objects: \(error)")
        }
    }

    // Delete All Objects with Predicate
    func deleteAllObject<T>(pedicate predicate: NSPredicate?, withType type: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        fetchRequest.predicate = predicate

        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                results.forEach { context.delete($0) }
                try context.save()
            }
        } catch {
            print("Error deleting all objects: \(error)")
        }
    }

    // Delete All Objects
    func deleteAllObjects() {
        let entities = persistentContainer.managedObjectModel.entities

        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? "")

            do {
                if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    results.forEach { context.delete($0) }
                }
            } catch {
                print("Error deleting all objects for entity \(entity.name ?? ""): \(error)")
            }
        }

        do {
            try context.save()
        } catch {
            print("Error saving context after deleting all objects: \(error)")
        }
    }

    func updateObject<T>(_ type: T.Type,
                         where query: String?,
                         with values: [String: Any]) -> Bool
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: String(describing: type)
        )
        if let query = query {
            fetchRequest.predicate = NSPredicate(format: query)
        }
        fetchRequest.fetchLimit = 1

        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject],
               let object = results.first
            {
                // Apply updates
                for (key, value) in values {
                    object.setValue(value, forKey: key)
                }

                let oldPolicy = context.mergePolicy
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                defer { context.mergePolicy = oldPolicy }

                try context.save()
                return true
            }
            return false
        } catch {
            print("Error updating \(type): \(error)")
            return false
        }
    }
}
