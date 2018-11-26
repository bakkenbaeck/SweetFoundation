//
//  PredicateKeyPathTests.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import CoreData
import XCTest

class PredicateKeyPathTests: XCTestCase {
    
    var moc: NSManagedObjectContext!
    
    var sortOfficesByName: [NSSortDescriptor] {
        return [NSSortDescriptor(keyPath: \Office.name, ascending: true)]
    }
    
    var sortEmployeesByName: [NSSortDescriptor] {
        return [NSSortDescriptor(keyPath: \Employee.name, ascending: true)]
    }
    
    var sortCompaniesByName: [NSSortDescriptor] {
        return [NSSortDescriptor(keyPath: \Company.name, ascending: true)]
    }
    
    var dunderMifflinFoundingDate: Date {
        return TestDateFactory.dateFrom(day: 24, month: 3, year: 2005)
    }
    
    var bbFoundingDate: Date {
        return TestDateFactory.dateFrom(day: 1, month: 1, year: 2008)
    }
    
    override func setUp() {
        super.setUp()
        
        let expectation = self.expectation(description: "Core data reset")
        CoreDataManager.shared.reset {
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 2)
        
        self.moc = CoreDataManager.shared.mainContext
        
        SampleDataFactory.loadSampleData(using: self.moc)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.moc = nil
    }
    
    // MARK: - Equals
    
    func testEqualsPredicateWithBool() throws {
        let openPredicate = NSPredicate(keyPath: \Office.isOpen,
                                        value: true)
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: openPredicate)
        
        XCTAssertEqual(fetchedOffices.count, 3)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "Bonn",
            "HQ", // capital sorted before lowercase
            "Hamsterdance",
        ])
    }
    
    func testEqualsPredicateWithDate() throws {
        let datePredicate = NSPredicate(keyPath: \Company.dateFounded,
                                        value: self.bbFoundingDate)
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     predicate: datePredicate)
        
        XCTAssertEqual(fetchedCompanies.count, 1)
        XCTAssertEqual(fetchedCompanies.map { $0.name }, ["Bakken & Bæck"])
    }
    
    func testEqualsPredicateWithInt() throws {
        let twentyEightPredicate = NSPredicate(keyPath: \Employee.age,
                                               value: 28)
        
        let twentyEightYearOlds = try self.moc.fetchAll(Employee.self,
                                                        sortDescriptors: self.sortEmployeesByName,
                                                        predicate: twentyEightPredicate)
        
        XCTAssertEqual(twentyEightYearOlds.count, 2)
        XCTAssertEqual(twentyEightYearOlds.map { $0.name }, [ "Daniël", "Tristan"])
    }
    
    func testEqualsPredicateWithObject() throws {
        let companyNamePredicate = NSPredicate(keyPath: \Company.name,
                                               value: "Dunder Mifflin")
        
        let companyResult = try self.moc.fetchAll(Company.self,
                                                  predicate: companyNamePredicate)
        
        guard let dunderMifflin = companyResult.first else {
            XCTFail("Could not access company to try object result")
            return
        }
        
        let companyPredicate = NSPredicate(keyPath: \Office.company,
                                           value: dunderMifflin)
        
        let officeResult = try self.moc.fetchAll(Office.self,
                                                 predicate: companyPredicate)
        
        XCTAssertEqual(officeResult.count, 1)
        XCTAssertEqual(officeResult.map { $0.name }, ["Scranton"])
    }
    
    func testEqualsPredicateWithString() throws {
        let ellenNamePredicate = NSPredicate(keyPath: \Employee.name,
                                             value: "Ellen")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     predicate: ellenNamePredicate)
        
        XCTAssertEqual(fetchedEmployees.count, 1)
        
        guard let ellen = fetchedEmployees.first else {
            XCTFail("Could not access employee")
            return
        }
        
        XCTAssertEqual(ellen.age, 37)
    }
    
    // MARK: Case And Diacritic For Strings
    
    func testEqualsPredicateWithStringChecksDiacritics() throws {
        let danielNameNoDiacritic = NSPredicate(keyPath: \Employee.name,
                                                value: "Daniel")
        
        let fetchedNoDiacritic = try self.moc.fetchAll(Employee.self,
                                                       predicate: danielNameNoDiacritic)
        
        XCTAssertEqual(fetchedNoDiacritic.count, 0)
    }
    
    func testEqualsPredicateWithStringChecksCase() throws {
        let danielNameWrongCase = NSPredicate(keyPath: \Employee.name,
                                              value: "daniël")
        
        let fetchedWrongCase = try self.moc.fetchAll(Employee.self,
                                                     predicate: danielNameWrongCase)
        XCTAssertEqual(fetchedWrongCase.count, 0)
    }
    
    func testCaseAndDiacriticInsensitiveEqualsPredicateWithString() throws {
        let danielNameCDPredicate = NSPredicate(keyPath: \Employee.name,
                                                operatorType: .equalsIgnoringCaseAndDiacritics,
                                                value: "daniel")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     predicate: danielNameCDPredicate)
        
        XCTAssertEqual(fetchedEmployees.count, 1)
        
        guard let daniel = fetchedEmployees.first else {
            XCTFail("Could not access employee")
            return
        }
        
        XCTAssertEqual(daniel.name, "Daniël")
    }
    
    func testNotEqualsPredicateWithStringChecksDiacritics() throws {
        let amsterdamOfficePredicate = NSPredicate(keyPath: \Employee.office?.name,
                                                   value: "Hamsterdance")
        let notDanielNoDiacritic = NSPredicate(keyPath: \Employee.name,
                                               operatorType: .notEqual,
                                               value: "Daniel")
        let hamstersNotDanielNoDiacritic = NSCompoundPredicate(andPredicateWithSubpredicates: [
            amsterdamOfficePredicate,
            notDanielNoDiacritic
        ])
        
        let fetchedNoDiacritic = try self.moc.fetchAll(Employee.self,
                                                       sortDescriptors: self.sortEmployeesByName,
                                                       predicate: hamstersNotDanielNoDiacritic)
        
        XCTAssertEqual(fetchedNoDiacritic.count, 3)
        XCTAssertEqual(fetchedNoDiacritic.map { $0.name }, [
            "Daniël",
            "Ellen",
            "Luuk"
        ])
    }
    
    func testNotEqualsPredicateWithStringChecksCase() throws {
        let amsterdamOfficePredicate = NSPredicate(keyPath: \Employee.office?.name,
                                                   value: "Hamsterdance")
        let notDanielNameWrongCase = NSPredicate(keyPath: \Employee.name,
                                                 operatorType: .notEqual,
                                                 value: "daniël")
        let hamstersNotDanielWrongCase = NSCompoundPredicate(andPredicateWithSubpredicates: [
            amsterdamOfficePredicate,
            notDanielNameWrongCase
        ])
        
        let fetchedWrongCase = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: hamstersNotDanielWrongCase)
        XCTAssertEqual(fetchedWrongCase.count, 3)
        XCTAssertEqual(fetchedWrongCase.map { $0.name }, [
            "Daniël",
            "Ellen",
            "Luuk"
        ])
    }
    
    func testCaseAndDiacriticNotEqualsPredicateWithString() throws {
        let amsterdamOfficePredicate = NSPredicate(keyPath: \Employee.office?.name,
                                                   value: "Hamsterdance")
        let notNamedDanielPredicate = NSPredicate(keyPath: \Employee.name,
                                                  operatorType: .notEqualIgnoringCaseAndDiacritics,
                                              value: "daniel")
        
        let hamstersNotDanielPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            amsterdamOfficePredicate,
            notNamedDanielPredicate
        ])
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: hamstersNotDanielPredicate)
        
        XCTAssertEqual(fetchedEmployees.count, 2)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Ellen", "Luuk" ])
    }

    // MARK: Not Equals
    
    func testNotEqualsPredicateWithBool() throws {
        let openPredicate = NSPredicate(keyPath: \Office.isOpen,
                                        operatorType: .notEqual,
                                        value: true)
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: openPredicate)
        
        XCTAssertEqual(fetchedOffices.count, 2)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "London",
            "Scranton"
        ])
    }
    
    func testNotEqualsPredicateWithDate() throws {
        let datePredicate = NSPredicate(keyPath: \Company.dateFounded,
                                        operatorType: .notEqual,
                                        value: self.bbFoundingDate)
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     predicate: datePredicate)
        
        XCTAssertEqual(fetchedCompanies.count, 1)
        XCTAssertEqual(fetchedCompanies.map { $0.name }, ["Dunder Mifflin"])
    }
    
    func testNotEqualsPredicateWithInt() throws {
        let amsterdamPredicate = NSPredicate(keyPath: \Employee.office?.name,
                                             value: "Hamsterdance")
        let not28Predicate = NSPredicate(keyPath: \Employee.age,
                                         operatorType: .notEqual,
                                         value: 28)
        let not28HamstersPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            amsterdamPredicate,
            not28Predicate
        ])
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: not28HamstersPredicate)
        
        XCTAssertEqual(fetchedEmployees.count, 2)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Ellen" , "Luuk" ])
    }
    
    func testNotEqualsPredicateWithObject() throws {
        let companyNamePredicate = NSPredicate(keyPath: \Company.name,
                                               value: "Dunder Mifflin")
        let companyResult = try self.moc.fetchAll(Company.self,
                                                  predicate: companyNamePredicate)
        
        guard let dunderMifflin = companyResult.first else {
            XCTFail("Could not access company to try object result")
            return
        }
        
        let notCompanyPredicate = NSPredicate(keyPath: \Office.company,
                                              operatorType: .notEqual,
                                              value: dunderMifflin)
        
        let officeResult = try self.moc.fetchAll(Office.self,
                                                 sortDescriptors: self.sortOfficesByName,
                                            predicate: notCompanyPredicate)
        
        XCTAssertEqual(officeResult.count, 4)
        XCTAssertEqual(officeResult.map { $0.name }, [
            "Bonn",
            "HQ",
            "Hamsterdance",
            "London"
        ])
    }
    
    // MARK: - Greater Than
    
    func testGreaterThanPredicateWithDouble() throws {
        let longOver0point2Predicate = NSPredicate(keyPath: \Office.longitude,
                                             operatorType: .greaterThan,
                                             value: 0.2)
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: longOver0point2Predicate)
        
        XCTAssertEqual(fetchedOffices.count, 3)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "Bonn",
            "HQ",
            "Hamsterdance",
        ])
    }
    
    func testGreaterThanPredicateWithDate() throws {
        let companyPredicate = NSPredicate(keyPath: \Company.dateFounded,
                                           operatorType: .greaterThan,
                                           value: self.dunderMifflinFoundingDate)
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     predicate: companyPredicate)
        
        XCTAssertEqual(fetchedCompanies.count, 1)
        XCTAssertEqual(fetchedCompanies.map { $0.name }, [ "Bakken & Bæck" ])
    }
    
    func testGreaterThanPredicateWithInteger() throws {        
        let over29Predicate = NSPredicate(keyPath: \Employee.age,
                                          operatorType: .greaterThan,
                                          value: 29)
        
        let olds = try self.moc.fetchAll(Employee.self,
                                         sortDescriptors: self.sortOfficesByName,
                                         predicate: over29Predicate)
        
        XCTAssertEqual(olds.count, 6)
        XCTAssertEqual(olds.map { $0.name }, [
            "Dwight",
            "Ellen",
            "Johan",
            "Michael",
            "Ole Martin",
            "Wolfgang",
        ])
    }
    
    func testGreaterThanPredicateWithString() throws {
        let greaterThanHQPredicate = NSPredicate(keyPath: \Office.name,
                                                 operatorType: .greaterThan,
                                                 value: "HQ")
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: greaterThanHQPredicate)
        
        XCTAssertEqual(fetchedOffices.count, 3)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "Hamsterdance",
            "London",
            "Scranton"
        ])
    }
    
    // MARK: Greater than or equal to
    
    func testGreaterThanOrEqualToPredicateWithDate() throws {
        let companyPredicate = NSPredicate(keyPath: \Company.dateFounded,
                                           operatorType: .greaterThanOrEqualTo,
                                           value: self.dunderMifflinFoundingDate)
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     sortDescriptors: self.sortCompaniesByName,
                                                     predicate: companyPredicate)
        
        XCTAssertEqual(fetchedCompanies.count, 2)
        XCTAssertEqual(fetchedCompanies.map { $0.name }, [ "Bakken & Bæck", "Dunder Mifflin" ])
    }
    
    func testGreaterThanOrEqualToPredicateWithInt() throws {
        let twentyNineOrOlderPredicate = NSPredicate(keyPath: \Employee.age,
                                                     operatorType: .greaterThanOrEqualTo,
                                                     value: 29)
        
        let semiOlds = try self.moc.fetchAll(Employee.self,
                                             sortDescriptors: self.sortOfficesByName,
                                             predicate: twentyNineOrOlderPredicate)
        
        XCTAssertEqual(semiOlds.count, 7)
        XCTAssertEqual(semiOlds.map { $0.name }, [
            "Dwight",
            "Ellen",
            "Jim",
            "Johan",
            "Michael",
            "Ole Martin",
            "Wolfgang",
        ])
    }
    
    func testGreaterThanOrEqualToPredicateWithString() throws {
        let greaterThanHQPredicate = NSPredicate(keyPath: \Office.name,
                                                 operatorType: .greaterThanOrEqualTo,
                                                 value: "HQ")
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: greaterThanHQPredicate)
        
        XCTAssertEqual(fetchedOffices.count, 4)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "HQ",
            "Hamsterdance",
            "London",
            "Scranton"
         ])
    }
    
    // MARK: - Less Than
    
    func testLessThanPredicateWithDouble() throws {
        let lessThanZeroPointTwoPredicate = NSPredicate(keyPath: \Office.longitude,
                                                operatorType: .lessThan,
                                                value: 0.2)
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: lessThanZeroPointTwoPredicate)
        XCTAssertEqual(fetchedOffices.count, 2)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "London",
            "Scranton",
        ])
        
    }
    
    func testLessThanPredicateWithDate() throws {
        let lessThanBBFoundingPredicate = NSPredicate(keyPath: \Company.dateFounded,
                                                      operatorType: .lessThan, value: self.bbFoundingDate)
        let retrievedCompanies = try self.moc.fetchAll(Company.self,
                                                       predicate: lessThanBBFoundingPredicate)
        XCTAssertEqual(retrievedCompanies.count, 1)
        XCTAssertEqual(retrievedCompanies.map { $0.name }, [ "Dunder Mifflin" ])
    }
    
    func testLessThanPredicateWithInt() throws {
        let under21Predicate = NSPredicate(keyPath: \Employee.age,
                                           operatorType: .lessThan,
                                           value: 21)
        
        let cantDrinkInTheUS = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: under21Predicate)
        
        XCTAssertEqual(cantDrinkInTheUS.count, 1)
        XCTAssertEqual(cantDrinkInTheUS.map { $0.name }, ["Tobias"])
    }
    
    func testLessThanPredicateWithString() throws {
        let lessThanL = NSPredicate(keyPath: \Employee.name,
                                    operatorType: .lessThan,
                                    value: "L")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: lessThanL)
        
        XCTAssertEqual(fetchedEmployees.count, 6)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [
            "Daniël",
            "Dwight",
            "Ellen",
            "Harry",
            "Jim",
            "Johan"
        ])
    }
    
    // MARK: Less Than or Equal To
    
    func testLessThanOrEqualToPredicateWithDate() throws {
        let bbOrEarlierFoundingPredicate = NSPredicate(keyPath: \Company.dateFounded,
                                                      operatorType: .lessThanOrEqualTo, value: self.bbFoundingDate)
        let retrievedCompanies = try self.moc.fetchAll(Company.self,
                                                       sortDescriptors: self.sortCompaniesByName,
                                                       predicate: bbOrEarlierFoundingPredicate)
        XCTAssertEqual(retrievedCompanies.count, 2)
        XCTAssertEqual(retrievedCompanies.map { $0.name }, [ "Bakken & Bæck", "Dunder Mifflin" ])
    }
    
    func testLessThanOrEqualToPredicateWithInt() throws {
        let twentyOneOrUnderPredicate = NSPredicate(keyPath: \Employee.age,
                                           operatorType: .lessThanOrEqualTo,
                                           value: 21)
        
        let cantDrinkInTheUS = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: twentyOneOrUnderPredicate)
        
        XCTAssertEqual(cantDrinkInTheUS.count, 2)
        XCTAssertEqual(cantDrinkInTheUS.map { $0.name }, ["Harry", "Tobias"])
    }
    
    func testLessThanOrEqualToPredicateWithString() throws {
        let lessThanOrEqualToLuuk = NSPredicate(keyPath: \Employee.name,
                                                operatorType: .lessThanOrEqualTo,
                                                value: "Luuk")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: lessThanOrEqualToLuuk)
        
        XCTAssertEqual(fetchedEmployees.count, 7)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [
            "Daniël",
            "Dwight",
            "Ellen",
            "Harry",
            "Jim",
            "Johan",
            "Luuk"
        ])
    }
    
    // MARK: - Between
    
    func testBetweenWithDates() throws {
        let daysAroundFoundingPredicate = NSPredicate.between(TestDateFactory.dateFrom(day: 2, month: 1, year: 2008), and: TestDateFactory.dateFrom(day: 31, month: 12, year: 2007), for: \Company.dateFounded)
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     predicate: daysAroundFoundingPredicate)
        XCTAssertEqual(fetchedCompanies.count, 1)
        XCTAssertEqual(fetchedCompanies.map { $0.name }, [ "Bakken & Bæck" ])
    }
    
    func testBetweenWithInts() throws {
        let thirtySevenToSixtyPredicate = NSPredicate.between(37,
                                                              and: 60,
                                                              for: \Employee.age)
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                              sortDescriptors: self.sortEmployeesByName,
                                              predicate: thirtySevenToSixtyPredicate)
        
        XCTAssertEqual(fetchedEmployees.count, 3)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [
          "Dwight",
          "Ellen",
          "Michael"
        ])
    }
    
    func testBetweenWithDoubles() throws {
        let zeroToFivePredicate = NSPredicate.between(0.1,
                                                      and: 5.0,
                                                      for: \Office.longitude)
        
        let fetchedOffices = try self.moc.fetchAll(Office.self,
                                                   sortDescriptors: self.sortOfficesByName,
                                                   predicate: zeroToFivePredicate)
        
        XCTAssertEqual(fetchedOffices.count, 2)
        XCTAssertEqual(fetchedOffices.map { $0.name }, [
            "Hamsterdance",
            "London"
        ])
    }
    
    // MARK: - String only stuff
    
    // MARK: Begins With
    
    func testBeginsWithString() throws {
        let beginsWithJ = NSPredicate(keyPath: \Employee.name,
                                      operatorType: .beginsWith,
                                      value: "J")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: beginsWithJ)
        
        XCTAssertEqual(fetchedEmployees.count, 2)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Jim", "Johan" ])
    }
    
    func testBeginsWithStringChecksCase() throws {
        let beginsWithJ = NSPredicate(keyPath: \Employee.name,
                                      operatorType: .beginsWith,
                                      value: "j")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: beginsWithJ)
        
        XCTAssertEqual(fetchedEmployees.count, 0)
    }
    
    func testBeginsWithStringChecksDiacritics() throws {
        let beginsWithDiacritic = NSPredicate(keyPath: \Employee.name,
                                             operatorType: .beginsWith,
                                             value: "Danië")
        
        let withDiacritic = try self.moc.fetchAll(Employee.self,
                                                  predicate: beginsWithDiacritic)
        XCTAssertEqual(withDiacritic.count, 1)
        XCTAssertEqual(withDiacritic.map { $0.name }, [ "Daniël" ])
        
        let beginsWithoutDiacritic = NSPredicate(keyPath: \Employee.name,
                                              operatorType: .beginsWith,
                                              value: "Danie")
        let withoutDiacritic = try self.moc.fetchAll(Employee.self,
                                                            predicate: beginsWithoutDiacritic)

        XCTAssertEqual(withoutDiacritic.count, 0)
    }
    
    func testBeginsWithStringCaseAndDiacriticInsensitive() throws {
        let beginsWrongCaseAndNoDiacritic = NSPredicate(keyPath: \Employee.name,
                                                        operatorType: .beginsWithIgnoringCaseAndDiacritics,
                                                        value: "danie")
        let withoutCaseOrDiacritic = try self.moc.fetchAll(Employee.self,
                                                           predicate: beginsWrongCaseAndNoDiacritic)
        
        XCTAssertEqual(withoutCaseOrDiacritic.count, 1)
        XCTAssertEqual(withoutCaseOrDiacritic.map { $0.name }, [ "Daniël" ])
    }
    
    // MARK: Contains
    
    func testContainsWithString() throws {
        let containsLowercaseAR = NSPredicate(keyPath: \Employee.name,
                                             operatorType: .contains,
                                             value: "ar")
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: containsLowercaseAR)
        
        XCTAssertEqual(fetchedEmployees.count, 2)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Harry", "Ole Martin" ])
    }
    
    func testContainsWithStringChecksCase() throws {
        let containsLowercaseW = NSPredicate(keyPath: \Employee.name,
                                                                       operatorType: .contains,
                                                                       value: "w")
        let lowercasedFetch = try self.moc.fetchAll(Employee.self,
                                                    predicate: containsLowercaseW)
        
        XCTAssertEqual(lowercasedFetch.count, 1)
        XCTAssertEqual(lowercasedFetch.map { $0.name }, [ "Dwight" ])
        

        let containsUppercaseW = NSPredicate(keyPath: \Employee.name,
                                             operatorType: .contains,
                                             value: "W")
        
        let uppercasedFetch = try self.moc.fetchAll(Employee.self,
                                                    predicate: containsUppercaseW)
        XCTAssertEqual(uppercasedFetch.count, 1)
        XCTAssertEqual(uppercasedFetch.map { $0.name }, [ "Wolfgang" ])
    }
    
    func testContainsWithStringChecksDiacritics() throws {
        let noDiacriticLowercaseEL = NSPredicate(keyPath: \Employee.name,
                                                 operatorType: .contains,
                                                 value: "el")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName, predicate: noDiacriticLowercaseEL)
        
        XCTAssertEqual(fetchedEmployees.count, 1)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Michael" ])
    }
    
    func testContainsWithStringCaseAndDiacriticInsensitive() throws {
        let noDiacriticLowercaseEL = NSPredicate(keyPath: \Employee.name,
                                                 operatorType: .containsIgnoringCaseAndDiacritics,
                                                 value: "el")
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName, predicate: noDiacriticLowercaseEL)
        XCTAssertEqual(fetchedEmployees.count, 3)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [
            "Daniël",
            "Ellen",
            "Michael"
        ])        
    }
    
    // MARK: Ends With
    
    func testEndsWithString() throws {
        let endsWithLowercaseN = NSPredicate(keyPath: \Employee.name,
                                             operatorType: .endsWith,
                                             value: "n")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: endsWithLowercaseN)

        XCTAssertEqual(fetchedEmployees.count, 4)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [
            "Ellen",
            "Johan",
            "Ole Martin",
            "Tristan"
        ])
    }
    
    func testEndsWithStringChecksCase() throws {
        let endsWithUppercaseN = NSPredicate(keyPath: \Employee.name,
                                             operatorType: .endsWith,
                                             value: "N")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: endsWithUppercaseN)
        
        XCTAssertEqual(fetchedEmployees.count, 0)
    }
    
    func testEndsWithStringChecksDiacritics() throws {
        let endsWithLowercaseELNoDiacritic = NSPredicate(keyPath: \Employee.name,
                                                         operatorType: .endsWith,
                                                         value: "el")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     predicate: endsWithLowercaseELNoDiacritic)
        
        XCTAssertEqual(fetchedEmployees.count, 1)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Michael" ])
    }
    
    func testEndsWithStringIgnoringCaseAndDiacritics() throws {
        let endsWithUppercaseELNoDiacritic = NSPredicate(keyPath: \Employee.name,
                                                         operatorType: .endsWithIgnoringCaseAndDiacritics,
                                                         value: "EL")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: endsWithUppercaseELNoDiacritic)
        
        XCTAssertEqual(fetchedEmployees.count, 2)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Daniël", "Michael" ])
    }
    
    // MARK: Like
    
    func testLikeWithString() throws {
        let aeSplat = NSPredicate(keyPath: \Company.name,
                                  operatorType: .like,
                                  value: "B*ck")
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     predicate: aeSplat)
        
        
        XCTAssertEqual(fetchedCompanies.count, 1)
        XCTAssertEqual(fetchedCompanies.map { $0.name }, ["Bakken & Bæck"])
    }
    
    func testLikeWithStringChecksCase() throws {
        let aeSplat = NSPredicate(keyPath: \Company.name,
                                  operatorType: .like,
                                  value: "b*ck")
        
        let fetchedCompanies = try self.moc.fetchAll(Company.self,
                                                     predicate: aeSplat)
        
        
        XCTAssertEqual(fetchedCompanies.count, 0)
    }
    
    func testLikeWithStringChecksDiacritics() throws {
        let elSplatNoDiacritic = NSPredicate(keyPath: \Employee.name,
                                  operatorType: .like,
                                  value: "D*el")
        
        let fetchedNoDiacritic = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: elSplatNoDiacritic)
        
        XCTAssertEqual(fetchedNoDiacritic.count, 0)
        
        let elSplatWithDiacritic = NSPredicate(keyPath: \Employee.name,
                                               operatorType: .like,
                                               value: "D*ël")
        
        let fetchedWithDiacritic = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: elSplatWithDiacritic)
        
        XCTAssertEqual(fetchedWithDiacritic.count, 1)
        XCTAssertEqual(fetchedWithDiacritic.map { $0.name }, [ "Daniël" ])
    }
    
    func testLikeWithStringIgnoringCaseAndDiacritics() throws {
        let elSplat = NSPredicate(keyPath: \Employee.name,
                                  operatorType: .likeIgnoringCaseAndDiacritics,
                                  value: "d*el")
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: elSplat)
        
        XCTAssertEqual(fetchedEmployees.count, 1)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Daniël" ])
    }
    
    // MARK: - Regular expressions
    
    func testRegexPredicateWithString() throws {
        let regex = try NSRegularExpression(pattern: "([a-z0-9])+@([a-z0-9])+\\.([a-z]){2}\\.([a-z]){2}", options: [.ignoreMetacharacters])

        let dotCoDotWhateverPredicate = NSPredicate.matches(regex,
                                                            for: \Employee.email)
        
        let fetchedEmployees = try self.moc.fetchAll(Employee.self,
                                                     sortDescriptors: self.sortEmployeesByName,
                                                     predicate: dotCoDotWhateverPredicate)
        
        XCTAssertEqual(fetchedEmployees.count, 2)
        XCTAssertEqual(fetchedEmployees.map { $0.name }, [ "Harry", "Tristan" ])
        XCTAssertEqual(fetchedEmployees.map { $0.email }, [
            "harry@wotsallthisthen.co.uk",
            "tristan@theupsidedown.co.au"
        ])
    }
}
