//
//  CoreDataManager.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: CoreDataManager.self)
        guard let url = bundle.url(forResource: "SampleData", withExtension: "momd") else {
            fatalError("Could not get url of MOM")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Could not load MOM")
        }
        
        let container = NSPersistentContainer(name: "SampleData", managedObjectModel: managedObjectModel)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [
            description
        ]
    
        return container
    }()
    
    public var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    public func workInBackground(_ task: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(task)
    }
    
    public func reset(completion: @escaping (() -> Void)) {
        let coordinator = self.persistentContainer.persistentStoreCoordinator
        
        coordinator.persistentStores.forEach { try? coordinator.remove($0) }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { _,_ in
            completion()
        })
    }
}
