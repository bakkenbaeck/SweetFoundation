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

    func testSerializer() {
        var dictionary: [String: Any] = ["": ""]
        var string = OrderedSerializer.string(from: dictionary)

        XCTAssertEqual(string, "{\"\":\"\"}")

        dictionary = ["key": "value"]
        string = OrderedSerializer.string(from: dictionary)

        XCTAssertEqual(string, "{\"key\":\"value\"}")

        dictionary = ["array": ["element1", "element2"]]
        string = OrderedSerializer.string(from: dictionary)

        XCTAssertEqual(string, "{\"array\":[\"element1\",\"element2\"]}")

        dictionary = ["dict": ["key1": "value1", "key2": "value2"]]
        string = OrderedSerializer.string(from: dictionary)

        XCTAssertEqual(string, "{\"dict\":{\"key1\":\"value1\",\"key2\":\"value2\"}}")

        dictionary = ["dictception": ["dict": ["key": "value"]]]
        string = OrderedSerializer.string(from: dictionary)

        XCTAssertEqual(string, "{\"dictception\":{\"dict\":{\"key\":\"value\"}}}")

        // Test ordering
        dictionary = ["b": [["c1": "d1"], ["c2": "c2"]], "a": ["d1": "d1", "a": "value"]]
        string = OrderedSerializer.string(from: dictionary)

        XCTAssertEqual(string, "{\"a\":{\"a\":\"value\",\"d1\":\"d1\"},\"b\":[{\"c1\":\"d1\"},{\"c2\":\"c2\"}]}")
    }
}
