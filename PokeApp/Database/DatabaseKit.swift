//
//  DatabaseKit.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import Foundation
import CoreData

class DatabaseHost {
    static let shared = DatabaseHost()
    private init() { }
    
    final lazy var host: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokeApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

class DatabaseKit<T: NSManagedObject> {
    
    final var context: NSManagedObjectContext {
        return DatabaseHost.shared.host.viewContext
    }
    
    final var backgroundContext: NSManagedObjectContext {
        let background = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        background.parent = context
        return background
    }
    
    final func writeWith(return model: T) -> Result<T, DatabaseError> {
        let result = write()
        switch result {
        case .success( _):
            return .success(model)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    final func writeWith(return model: [T]) -> Result<[T], DatabaseError> {
        let result = write()
        switch result {
        case .success( _):
            return .success(model)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    final func write() -> Result<Bool, DatabaseError> {
        do {
            try self.context.save()
            return .success(true)
        } catch let error {
            return .failure(DatabaseError.custom(error.localizedDescription))
        }
    }
    
    final func read(predicate: NSCompoundPredicate? = nil) -> Result<[T], DatabaseError> {
        var results = [T]()
        let fetchRequest = NSFetchRequest<T>(entityName: T.nameOfClass)
        if let filter = predicate {
            fetchRequest.predicate = filter
        }
        do {
            results = try context.fetch(fetchRequest)
            return .success(results)
        } catch {
            return .failure(.readError)
        }
    }
    
    final func removeContext(_ object: T) {
        self.context.delete(object)
    }
    
    final func removeAll() -> Result<Bool, DatabaseError> {
        let fetch = self.read()
        switch fetch {
        case .success(let models):
            var itemDeleted = [Int]()
            for model in models {
                self.context.performAndWait {
                    self.removeContext(model)
                    itemDeleted.append(1)
                }
            }
            if itemDeleted.count == models.count {
                return .success(true)
            }
            return .success(false)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    final func generateUuid(label: String?) -> String {
        if let label = label {
            return "\(label):\(UUID().uuidString)"
        }
        return UUID().uuidString
    }
    
    final func readDistinct(predicate: NSCompoundPredicate? = nil) -> Result<[T], DatabaseError> {
        var results = [T]()
        let fetchRequest = NSFetchRequest<T>(entityName: T.nameOfClass)
        if let filter = predicate {
            fetchRequest.predicate = filter
        }
        fetchRequest.returnsDistinctResults = true
        do {
            results = try context.fetch(fetchRequest)
            return .success(results)
        } catch {
            return .failure(.readError)
        }
    }
}
