//
//  NSPredicate+Sweetness.swift
//  SweetFoundation
//
//  Created by Ellen Shapiro on 11/23/18.
//

import Foundation

// Inspired by https://github.com/kishikawakatsumi/Kuery/blob/master/Sources/Kuery/ManagedObjectProperty.swift
public protocol Property {
    var _object: AnyObject { get }
}

public protocol EquatableProperty: Property {}
public protocol ComparableProperty: EquatableProperty {}

extension NSObject: ComparableProperty {
    public var _object: AnyObject { return self }
}

extension Bool: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Int16: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Int32: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Int64: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Int: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Float: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Double: ComparableProperty {
    public var _object: AnyObject { return NSNumber(value: self) }
}
extension Date: ComparableProperty {
    public var _object: AnyObject { return self as NSDate }
}
extension String: ComparableProperty {
    public var _object: AnyObject { return self as NSString }
}

extension KeyPath {
    
    public var toNSString: NSString {
        return self._kvcKeyPathString! as NSString
    }
}

extension NSPredicate {
    
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
    // The following operators get their own factory initializers:
    // - MATCHES, since it takes a regular expression.
    // - BETWEEN, since it takes multiple parameters.
    public enum PredicateOperator: String {
        case beginsWith = "BEGINSWITH"
        case beginsWithIgnoringCaseAndDiacritics = "BEGINSWITH[cd]"
        case contains = "CONTAINS"
        case containsIgnoringCaseAndDiacritics = "CONTAINS[cd]"
        case endsWith = "ENDSWITH"
        case endsWithIgnoringCaseAndDiacritics = "ENDSWITH[cd]"
        case equals = "=="
        case equalsIgnoringCaseAndDiacritics = "==[cd]"
        case greaterThan = ">"
        case greaterThanOrEqualTo = ">="
        case lessThan = "<"
        case lessThanOrEqualTo = "<="
        case like = "LIKE"
        case likeIgnoringCaseAndDiacritics = "LIKE[cd]"
        case notEqual = "!="
        case notEqualIgnoringCaseAndDiacritics = "!=[cd]"
    }
    
    public convenience init<Root, Property: ComparableProperty>(keyPath: KeyPath<Root, Property?>,
                                                                operatorType: PredicateOperator = .equals,
                                                                value: Property) {
        self.init(format: "%K \(operatorType.rawValue) %@",
            argumentArray: [
                keyPath.toNSString,
                value._object
            ])
    }
    
    public convenience init<Root, Property: ComparableProperty>(keyPath: KeyPath<Root, Property>,
                                                                operatorType: PredicateOperator = .equals,
                                                                value: Property) {
        self.init(format: "%K \(operatorType.rawValue) %@",
            argumentArray: [
                keyPath.toNSString,
                value._object
            ])
    }
        
    public static func matches<Root, Property: ComparableProperty>(_ regex: NSRegularExpression,
                                                                   for keyPath: KeyPath<Root, Property>) -> NSPredicate {
        return NSPredicate(
            format: "%K MATCHES %@",
            argumentArray: [
                keyPath.toNSString,
                regex.pattern
            ])
    }
    
    public static func matches<Root, Property: ComparableProperty>(_ regex: NSRegularExpression,
                                                                   for keyPath: KeyPath<Root, Property?>) -> NSPredicate {
        return NSPredicate(
            format: "%K MATCHES %@",
            argumentArray: [
                keyPath.toNSString,
                regex.pattern
            ])
    }
    
    public static func between<Root, Property: ComparableProperty>(_ firstValue: Property,
                                                                   and secondValue: Property,
                                                                   for keyPath: KeyPath<Root, Property>) -> NSPredicate{
        // BETWEEN doesn't work with floating point numbers, so it's time for a hack!
        if firstValue is Float || firstValue is Double || firstValue is NSDecimalNumber {
            return self.fakeBetween(firstValue, and: secondValue, for: keyPath)
        } else {
            return NSPredicate(
                format: "%K BETWEEN %@",
                argumentArray: [
                    keyPath.toNSString,
                    [ firstValue._object, secondValue._object ]
                ])
        }
    }
    
    public static func between<Root, Property: ComparableProperty>(_ firstValue: Property,
                                                                   and secondValue: Property,
                                                                   for keyPath: KeyPath<Root, Property?>) -> NSPredicate {
        // BETWEEN doesn't work with floating point numbers, so it's time for a hack!
        if firstValue is Float || firstValue is Double || firstValue is NSDecimalNumber {
            return self.fakeOptionalBetween(firstValue, and: secondValue, for: keyPath)
        } else {
            return NSPredicate(
                format: "%K BETWEEN %@",
                argumentArray: [
                    keyPath.toNSString,
                    [ firstValue._object, secondValue._object ]
                ])
        }
    }
    
    private static func fakeBetween<Root, Property: ComparableProperty>(_ firstValue: Property,
                                                                        and secondValue: Property,
                                                                        for keyPath: KeyPath<Root, Property>) -> NSPredicate {
        let greaterThanOrEqualToFirst = NSPredicate(keyPath: keyPath,
                                                    operatorType: .greaterThanOrEqualTo,
                                                    value: firstValue)
        let lessThanOrEqualToSecond = NSPredicate(keyPath: keyPath,
                                                  operatorType: .lessThanOrEqualTo,
                                                  value: secondValue)
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            greaterThanOrEqualToFirst,
            lessThanOrEqualToSecond
            ])
    }
    
    private static func fakeOptionalBetween<Root, Property: ComparableProperty>(_ firstValue: Property,
                                                                        and secondValue: Property,
                                                                        for keyPath: KeyPath<Root, Property?>) -> NSPredicate {
        let greaterThanOrEqualToFirst = NSPredicate(keyPath: keyPath,
                                                    operatorType: .greaterThanOrEqualTo,
                                                    value: firstValue)
        let lessThanOrEqualToSecond = NSPredicate(keyPath: keyPath,
                                                  operatorType: .lessThanOrEqualTo,
                                                  value: secondValue)
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: [
            greaterThanOrEqualToFirst,
            lessThanOrEqualToSecond
        ])
    }
}
