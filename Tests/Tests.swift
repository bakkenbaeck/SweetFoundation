import XCTest

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

    func testValidEmail() {
        let validEmail = "marijn@bakkenbaeck.no"
        let validEmail2 = "marijn@bakkenbaeck.amsterdam"
        let validEmail3 = "valid@mail.n"
        let invalidEmail1 = "invalidemail.nl"
        let invalidEmail2 = "@invalidemail.nl"
        let invalidEmail3 = "invalid@@email.nl"

        XCTAssertTrue(validEmail.isValidEmail)
        XCTAssertTrue(validEmail2.isValidEmail)
        XCTAssertTrue(validEmail3.isValidEmail)
        XCTAssertFalse(invalidEmail1.isValidEmail)
        XCTAssertFalse(invalidEmail2.isValidEmail)
        XCTAssertFalse(invalidEmail3.isValidEmail)
    }
}
