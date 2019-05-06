import Foundation

public extension Collection {
    func element(at index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
