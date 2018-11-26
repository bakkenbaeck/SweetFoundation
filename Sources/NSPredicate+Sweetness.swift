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

extension NSPredicate {
    
    // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
    // NOTE: MATCHES gets its own specific initializer since it takes a regular expression.
    public enum PredicateOperator: String {
        case beginsWith = "BEGINSWITH"
        case beginsWithIgnoringCaseAndDiacritics = "BEGINSWITH[cd]"
        case between = "BETWEEN"
        case contains = "CONTAINS"
        case containsIgnoringCaseAndDiacritics = "CONTAINS[cd]"
        case endsWith = "ENDSWITH"
        case endsWithIgnoringCaseAndDiacritics = "ENDSWITH[cd]"
        case equals = "=="
        case equalsIgnoringCaseAndDiacritics = "==[cd]"
        case greaterThan = ">"
        case greaterThanOrEqualTo = ">="
        case `in` = "IN"
        case lessThan = "<"
        case lessThanOrEqualTo = "<="
        case like = "LIKE"
        case likeIgnoringCaseAndDiacritics = "LIKE[cd]"
        case notEqual = "!="
    }
    
    public enum AggregatePredicateOperatior: String {
        case any = "ANY"
        case all = "ALL"
        case none = "NONE"
    }
    
    public convenience init<Root, Property: ComparableProperty>(keyPath: KeyPath<Root, Property?>,
                                                                operatorType: PredicateOperator = .equals,
                                                                value: Property) {
        self.init(format: "%K \(operatorType.rawValue) %@",
            argumentArray: [
                keyPath._kvcKeyPathString! as NSString,
                value._object
            ])
    }
    
    public convenience init<Root, Property: ComparableProperty>(keyPath: KeyPath<Root, Property>,
                                                                operatorType: PredicateOperator = .equals,
                                                                value: Property) {
        self.init(format: "%K \(operatorType.rawValue) %@",
            argumentArray: [
                keyPath._kvcKeyPathString! as NSString,
                value._object
            ])
    }
        
    public static func matches<Root, Property: ComparableProperty>(_ regex: NSRegularExpression, for keyPath: KeyPath<Root, Property>) -> NSPredicate {
        return NSPredicate(format: "%K MATCHES %@",
                           argumentArray: [
                              keyPath._kvcKeyPathString! as NSString,
                              regex
                           ])
    }
    
    public convenience init<Root, Property: ComparableProperty>(aggregate: AggregatePredicateOperatior,
                                                                keyPath: KeyPath<Root, Property>,
                                                                operatorType: PredicateOperator = .equals,
                                                                value: Property) {
        self.init(format: "%@ %K %@ %@",
                  argumentArray: [
                    aggregate.rawValue,
                    keyPath._kvcKeyPathString! as NSString,
                    operatorType.rawValue,
                    value._object
                  ])
    }
}
