import Foundation

public extension Array {

    @available(swift, deprecated: 4.2, message: "Use the standard library's `.randomElement()` method instead.")
    public var any: Element? {
        return self.randomElement()
    }
}
