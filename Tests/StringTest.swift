import Foundation
import XCTest

class StringTests: XCTestCase {
    func testLength() {
        let str = "12u389hnakms;amsnjvb1082hrp12m;"
        XCTAssertEqual(str.length, str.characters.count)
    }
}

