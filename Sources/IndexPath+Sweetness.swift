import Foundation

public extension IndexPath {
    public enum Direction {
        case same
        case before
        case ahead
    }

    fileprivate func comparePosition(_ ownRow: Int, otherRow: Int) -> Direction {
        if ownRow == otherRow {
            return .same
        } else if ownRow < otherRow {
            return .before
        } else {
            return .ahead
        }
    }

    public func comparePosition(to indexPath: IndexPath) -> Direction {
        if self.section == indexPath.section {
            return self.comparePosition(self.row, otherRow: indexPath.row)
        } else if self.section < indexPath.section {
            return .before
        } else {
            return .ahead
        }
    }
}
