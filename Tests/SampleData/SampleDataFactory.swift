//
//  SampleDataFactory.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import CoreData
import SweetFoundation

struct SampleDataFactory {
    
    // MARK: - Dummy data
    
    static let sampleEmailDomains = [
        "gmail.com",
        "bakkenbaeck.no",
        "yahoo.com",
        "seemslegit.biz",
        "vanity.io",
        "wotsallthisthen.co.uk",
    ]
    
    static var foundingDate: Date {
        return TestDateFactory.dateFrom(day: 1, month: 1, year: 2008)
    }
    
    private static let bbOffices = [
        [
            "name": "HQ",
            "lat": 59.9139,
            "lng": 10.7522,
            "open": true
        ],
        [
            "name": "Bonn",
            "lat": 50.7374,
            "lng": 7.0982,
            "open": true
        ],
        [
            "name": "Hamsterdance",
            "lat": 52.3680,
            "lng": 4.9036,
            "open": true
        ],
        [
            "name": "London",
            "lat": 51.5074,
            "lng": 0.1278,
            "open": false
        ]
    ]
    
    private static let employeesByOffice = [
        [
            [
                "name": "Johan",
                "age": 99
            ],
            [
                "name": "Tobias",
                "age": 12
            ],
            [
                "name": "Ole Martin",
                "age": 36
            ],
            [
                "name": "Yuliia",
                "age": 24
            ]
        ],
        [
            [
                "name": "Tristan",
                "age": 28
            ],
            [
                "name": "Wolfgang",
                "age": 34
            ],
            [
                "name": "Natasha",
                "age": 27
            ]
        ],
        [
            [
                "name": "Ellen",
                "age": 37
            ],
            [
                "name": "Daniël",
                "age": 28
            ]
        ],
        [
            [
                "name": "Harry",
                "age": 21
            ]
        ]
    ]
    
    // MARK: - Actual data creation
    
    static func loadSampleData(using context: NSManagedObjectContext) {
        
        _ = self.createSampleCompany(in: context,
                                     named: "Dunder Mifflin",
                                     founded: TestDateFactory.dateFrom(day: 24, month: 3, year: 2005))
        
        let company = self.createSampleCompany(in: context,
                                               named: "Bakken & Bæck",
                                               founded: self.foundingDate)
        
        let offices = bbOffices.map { self.createSampleOffice(in: context,
                                                              of: company,
                                                              using: $0) }
        
        for (index, office) in offices.enumerated() {
            let employeesOfOffice = self.employeesByOffice[index]
            
            employeesOfOffice.forEach { self.createSampleEmployee(in: context,
                                                                  at: office,
                                                                  using: $0) }
        }
        
        context.performAndWait {
            try? context.save()
        }        
    }
    
    private static func createSampleCompany(in context: NSManagedObjectContext,
                                            named name: String,
                                            founded: Date) -> Company {
        let company = Company(context: context)
        
        company.name = name
        company.dateFounded = founded
        
        return company
    }
    
    private static func createSampleOffice(in context: NSManagedObjectContext,
                                           of company: Company,
                                           using dictionary: [AnyHashable: Any]) -> Office {
        let office = Office(context: context)
        
        office.company = company
        office.name = (dictionary["name"] as? String)!
        office.latitude = (dictionary["lat"] as? Double)!
        office.longitude = (dictionary["lng"] as? Double)!
        office.isOpen = (dictionary["open"] as? Bool)!
        
        return office
    }
    
    @discardableResult
    private static func createSampleEmployee(in context: NSManagedObjectContext,
                                             at office: Office,
                                             using dictionary: [AnyHashable: Any]) -> Employee {
        let employee = Employee(context: context)
        
        employee.office = office
        employee.name = (dictionary["name"] as? String)!
        employee.age = Int16((dictionary["age"] as? Int)!)

        guard let randomDomain = self.sampleEmailDomains.randomElement() else {
            // Employee just won't have an email address
            return employee
        }
        
        if let name = employee.name {
            let strippedDiacritics = name.folding(options: .diacriticInsensitive, locale: .current)
            let nameWithoutSpaces = strippedDiacritics.replacingOccurrences(of: " ", with: "")
            
            employee.email = "\(nameWithoutSpaces)@\(randomDomain)"
        }
        
        return employee
    }
}
