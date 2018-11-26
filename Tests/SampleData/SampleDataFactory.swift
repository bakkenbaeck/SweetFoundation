//
//  SampleDataFactory.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import CoreData
import SweetFoundation
import XCTest

class SampleDataFactory {
    
    enum Error: Swift.Error {
        case couldntParseJSON(String)
        case couldntParseDate
    }
    
    // MARK: - Actual data creation
    
    static func loadSampleData(using context: NSManagedObjectContext, file: StaticString = #file,
                               line: UInt = #line) {
        guard let path = Bundle(for: self).path(forResource: "SampleData", ofType: "json") else {
            XCTFail("Failed to get path for sample data file!",
                    file: file,
                    line: line)
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let companyArray = json as? [[AnyHashable: Any]] else {
                XCTFail("Could not get proper json type",
                        file: file,
                        line: line)
                return
            }
            
            try companyArray.forEach {
                try self.createSampleCompany(in: context, from: $0)
            }
        } catch {
            XCTFail("Could not load data: \(error)",
                    file: file,
                    line: line)
            return
        }
        
        context.performAndWait {
            try? context.save()
        }        
    }
    
    @discardableResult
    private static func createSampleCompany(in context: NSManagedObjectContext,
                                            from dictionary: [AnyHashable: Any]) throws -> Company {
        let company = Company(context: context)
        
        guard
            let name = dictionary["name"] as? String,
            let dateFoundedString = dictionary["founded"] as? String,
            let officeDicts = dictionary["offices"] as? [[AnyHashable: Any]] else {
                throw Error.couldntParseJSON("Parsing company")
        }
        
        company.name = name
    
        let bits = dateFoundedString
            .components(separatedBy: "-")
            .compactMap { Int($0) }
        
        guard bits.count == 3 else {
            throw Error.couldntParseDate
        }
        
        company.dateFounded = TestDateFactory.dateFrom(day: bits[0], month: bits[1], year: bits[2])
        
        try officeDicts.forEach {
            try self.createSampleOffice(in: context, of: company, using: $0)
        }
        
        return company
    }
    
    @discardableResult
    private static func createSampleOffice(in context: NSManagedObjectContext,
                                           of company: Company,
                                           using dictionary: [AnyHashable: Any]) throws -> Office {
        let office = Office(context: context)
        
        office.company = company
        
        guard
            let name = dictionary["name"] as? String,
            let latitude = dictionary["lat"] as? Double,
            let longitude = dictionary["lng"] as? Double,
            let isOpen = dictionary["open"] as? Bool,
            let employeeDicts = dictionary["employees"] as? [[AnyHashable: Any]] else {
                throw Error.couldntParseJSON("One of the offices")
        }
        
        office.name = name
        office.latitude = latitude
        office.longitude = longitude
        office.isOpen = isOpen
        
        try employeeDicts.forEach {
            try self.createSampleEmployee(in: context, at: office, using: $0)
        }
        
        return office
    }
    
    @discardableResult
    private static func createSampleEmployee(in context: NSManagedObjectContext,
                                             at office: Office,
                                             using dictionary: [AnyHashable: Any]) throws -> Employee {
        let employee = Employee(context: context)
        
        employee.office = office
        
        guard
            let name = dictionary["name"] as? String,
            let age = dictionary["age"] as? Int16,
            let email = dictionary["email"] as? String else {
                throw Error.couldntParseJSON("One of the employees")
        }
        
        employee.name = name
        employee.age = age
        employee.email = email
        
        return employee
    }
}
