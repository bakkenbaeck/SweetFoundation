//
//  NSManagedObject+Sweetness.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import CoreData

extension NSManagedObject {
    
    @available(iOSApplicationExtension 10, *)
    public static var computedEntityName: String {
        guard let entityName = self.entity().name else {
            fatalError("Could not get entity name for \(String(describing: self))")
        }
        
        return entityName
    }
    
    @available(iOSApplicationExtension 10, *)
    public static func typedFetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: self.computedEntityName)
    }
}

