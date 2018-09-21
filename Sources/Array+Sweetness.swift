import Foundation

public extension Array {

    @available(*, deprecated, message: "Use the standard library's `.randomElement()` method instead.")
    public var any: Element? {
        return self.randomElement()
    }
}
