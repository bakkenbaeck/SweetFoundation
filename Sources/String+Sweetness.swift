import Foundation

public extension String {
    public var paddedForBase64: String {
        let length = self.decomposedStringWithCanonicalMapping.characters.count
        let paddingString = "="
        let paddingLength = length % 4

        if paddingLength > 0 {
            let paddingCharCount = 4 - paddingLength

            return self.padding(toLength: length + paddingCharCount, withPad: paddingString, startingAt: 0)
        } else {
            return self
        }
    }
}
