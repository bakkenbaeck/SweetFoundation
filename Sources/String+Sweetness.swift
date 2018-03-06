import Foundation

public protocol _StringIndex {}
extension String.Index: _StringIndex {}

public extension Range where Bound: _StringIndex {
    /// Translates a Range<String.Index> into a correct NSRange for use with NSStrings.
    /// Should help avoind all the `as String` or `as NSString` casting.
    ///
    /// - Parameter string: string where ranges will be applied. Necessary to ensure that multi-byte code-points are treated properly.
    /// - Returns: the NSRange representation of a Range<String.Index> for the given string.
    public func nsRange(on string: String) -> NSRange {
        guard let lowerBound = self.lowerBound as? String.Index, let upperBound = self.upperBound as? String.Index else {
            fatalError("Could not cast range bounds as String.Index.")
        }

        // always use utf16, as it's the internal representation of NSStrings, to ensure that clusters are counted correctly
        let location = string.utf16.distance(from: string.utf16.startIndex, to: lowerBound)
        let length = string.utf16.distance(from: lowerBound, to: upperBound)

        return NSRange(location: location, length: length)
    }
}

public extension NSRange {
    public func range(on string: NSString) -> Range<String.Index>? {
        let substring = string.substring(with: self)

        return (string as String).range(of: substring)
    }

    public func range(on string: String) -> Range<String.Index>? {
        guard let substring = string.substring(with: self) else { fatalError("Range out of bounds for string.") }

        return (string).range(of: substring)
    }
}

public extension String {
    public var wholeRange: Range<String.Index> {
        return self.range(of: self)!
    }

    public var paddedForBase64: String {
        let length = self.decomposedStringWithCanonicalMapping.count
        let paddingString = "="
        let paddingLength = length % 4

        if paddingLength > 0 {
            let paddingCharCount = 4 - paddingLength

            return self.padding(toLength: length + paddingCharCount, withPad: paddingString, startingAt: 0)
        } else {
            return self
        }
    }

    public func substring(with nsRange: NSRange) -> Substring? {
        guard let range = nsRange.range(on: self as NSString) else { return nil }

        return self[range]
    }

    public func nsRange(of string: String) -> NSRange {
        return (self as NSString).range(of: string)
    }
}
