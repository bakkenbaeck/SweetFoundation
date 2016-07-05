import Foundation
import XCTest

class RandomAccessCollectionTests: XCTestCase {
    func testEnumerateWithNext() {
        let ary = [1,2,3,4,5,6,7,8,9,0,"a","b","c","d","e"]
        for (current, next) in ary.enumerateWithNext() {
            XCTAssert(current as? Int == 1)
            if let next = next as? Int{
                XCTAssert(next == 2)
            }
            break
        }
    }
}
