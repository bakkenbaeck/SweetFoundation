import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    public func element(at index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
