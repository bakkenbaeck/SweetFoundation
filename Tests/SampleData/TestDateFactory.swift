//
//  DateFactory.swift
//  Tests
//
//  Created by Ellen Shapiro on 11/23/18.
//

import Foundation
import XCTest

struct TestDateFactory {
    
    static func dateFrom(day: Int,
                         month: Int,
                         year: Int,
                         timeZone: TimeZone = .current,
                         file: StaticString = #file,
                         line: UInt = #line) -> Date {
        
        let calendar = Calendar.current
        
        var components = DateComponents()
        
        components.day = day
        components.month = month
        components.year = year
        components.timeZone = timeZone
        
        guard let date = calendar.date(from: components) else {
            XCTFail("Could not create date from d: \(day) m: \(month) y: \(year)",
                    file: file,
                    line: line)
            return Date()
        }
        
        return date
    }
    
}
