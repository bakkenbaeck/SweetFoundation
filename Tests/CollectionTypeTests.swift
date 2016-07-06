import Foundation
import XCTest

class CollectionTypeTests: XCTestCase {
    func testEnumerateWithNext() {
        let ary = [1,2,3]
        for (current, next) in ary.enumeratedWithNext() {
            XCTAssert(current == 1)
            XCTAssert(next == 2)
            break
        }

        for (current, next) in ary.enumeratedWithNext() {
            if current == 2 {
                XCTAssert(next == 3)
            }
            break
        }
    }
}
