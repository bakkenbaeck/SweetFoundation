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
        let valid1 = "marijn@bakkenbaeck.no"
        let valid2 = "marijn@bakkenbaeck.amsterdam"
        let valid3 = "igor+testing@email.com"
        let valid4 = "テスツ@email.com"
        let valid5 = "üøçæ_123@email.com"

        let invalid1 = "invalide@mail.n"
        let invalid2 = "invalidemail.nl"
        let invalid3 = "@invalidemail.nl"
        let invalid4 = "invalid@@email.nl"

        XCTAssertTrue(valid1.isValidEmail)
        XCTAssertTrue(valid2.isValidEmail)
        XCTAssertTrue(valid3.isValidEmail)
        XCTAssertTrue(valid4.isValidEmail)
        XCTAssertTrue(valid5.isValidEmail)

        XCTAssertFalse(invalid1.isValidEmail)
        XCTAssertFalse(invalid2.isValidEmail)
        XCTAssertFalse(invalid3.isValidEmail)
        XCTAssertFalse(invalid4.isValidEmail)
    }
}
