import XCTest
@testable import SweetFoundationMac

class Tests: XCTestCase {
    func testMath() {
        var d = Math.degreesToRadians(45)
        var almostRight = d <= 0.786 && d >= 0.785
        XCTAssert(almostRight)

        d = Math.degreesToRadians(65)
        almostRight = d <= 1.135 && d >= 1.134
        XCTAssert(almostRight)

        d = Math.radiansToDegrees(M_PI)
        almostRight = d <= 180.1 && d >= 179.99
        XCTAssert(almostRight)

        d = Math.radiansToDegrees(M_PI / 2)
        almostRight = d <= 90.1 && d >= 89.99
        XCTAssert(almostRight)
    }

    func testBase64() {
        var string = "This is a test string"
        var string64 = string.data(using: .utf8)!.base64EncodedString()
        var string64NoPadding = string.data(using: .utf8)!.base64EncodedStringWithoutPadding()

        XCTAssertEqual(string64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5n")
        XCTAssertEqual(string64NoPadding, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5n")
        XCTAssertEqual(string64NoPadding.paddedForBase64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5n")

        string = "This is a test string without padding"
        string64 = string.data(using: .utf8)!.base64EncodedString()
        string64NoPadding = string.data(using: .utf8)!.base64EncodedStringWithoutPadding()

        XCTAssertEqual(string64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nIHdpdGhvdXQgcGFkZGluZw==")
        XCTAssertEqual(string64NoPadding, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nIHdpdGhvdXQgcGFkZGluZw")
        XCTAssertEqual(string64NoPadding.paddedForBase64, "VGhpcyBpcyBhIHRlc3Qgc3RyaW5nIHdpdGhvdXQgcGFkZGluZw==")

        string = "One-pad string"
        string64 = string.data(using: .utf8)!.base64EncodedString()
        string64NoPadding = string.data(using: .utf8)!.base64EncodedStringWithoutPadding()

        XCTAssertEqual(string64, "T25lLXBhZCBzdHJpbmc=")
        XCTAssertEqual(string64NoPadding, "T25lLXBhZCBzdHJpbmc")
        XCTAssertEqual(string64NoPadding.paddedForBase64, "T25lLXBhZCBzdHJpbmc=")
    }
}
