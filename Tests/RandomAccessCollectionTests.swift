import Foundation
import XCTest

class RandomAccessCollectionTests: XCTestCase {
    func testEnumerateWithNext() {
        let ary = [1,2,3]
        for (current, next) in ary.enumerateWithNext() {
            XCTAssert(current == 1)
            if let next = next {
                XCTAssert(next == 2)
            }
            break
        }
    }

    func testEnumerateWithPrevious() {
        let ary = [1,2,3]
        for (previous, current) in ary.enumerateWithPrevious() {
            if current == 1 { continue }
            XCTAssert(current == 2)
            if let previous = previous {
                XCTAssert(previous == 1)
            }
            break
        }
    }
}
