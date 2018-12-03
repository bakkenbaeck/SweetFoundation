//
//  NSManagedObjectContext+Sweetness.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import CoreData

extension NSManagedObjectContext {
    
    enum SweetError: Error {
        case couldNotFetchWithGenericType
    }
    
    @available(iOSApplicationExtension 10, *)
    public func fetchAll<T: NSManagedObject>(_ type: T.Type,
                                             sortDescriptors: [NSSortDescriptor]? = nil,
                                             predicate: NSPredicate? = nil) throws -> [T] {
        let fetchRequest = T.typedFetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let result = try self.fetch(fetchRequest)
        guard let typedResult = result as? [T] else {
            throw SweetError.couldNotFetchWithGenericType
        }
        return typedResult
    }
}
