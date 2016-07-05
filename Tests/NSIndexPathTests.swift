import UIKit
import XCTest

class NSIndexPathTests: XCTestCase {
    func testPositionComparison() {
        let firstPath = NSIndexPath(forRow: 0, inSection: 0)
        let secondPath = NSIndexPath(forRow: 1, inSection: 0)
        let thirdPath = NSIndexPath(forRow: 0, inSection: 1)
        let fourthPath = NSIndexPath(forRow: 1, inSection: 1)

        XCTAssert(firstPath.comparePosition(to: firstPath) == .Same)
        XCTAssert(firstPath.comparePosition(to: secondPath) == .Before)
        XCTAssert(firstPath.comparePosition(to: thirdPath) == .Before)
        XCTAssert(firstPath.comparePosition(to: fourthPath) == .Before)

        XCTAssert(secondPath.comparePosition(to: firstPath) == .Ahead)
        XCTAssert(secondPath.comparePosition(to: secondPath) == .Same)
        XCTAssert(secondPath.comparePosition(to: thirdPath) == .Before)
        XCTAssert(secondPath.comparePosition(to: fourthPath) == .Before)

        XCTAssert(thirdPath.comparePosition(to: firstPath) == .Ahead)
        XCTAssert(thirdPath.comparePosition(to: secondPath) == .Ahead)
        XCTAssert(thirdPath.comparePosition(to: thirdPath) == .Same)
        XCTAssert(thirdPath.comparePosition(to: fourthPath) == .Before)

        XCTAssert(fourthPath.comparePosition(to: firstPath) == .Ahead)
        XCTAssert(fourthPath.comparePosition(to: secondPath) == .Ahead)
        XCTAssert(fourthPath.comparePosition(to: thirdPath) == .Ahead)
        XCTAssert(fourthPath.comparePosition(to: fourthPath) == .Same)
    }
}
