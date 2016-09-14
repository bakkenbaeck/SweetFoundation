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
        if (self as NSIndexPath).section == (indexPath as NSIndexPath).section {
            return self.comparePosition((self as NSIndexPath).row, otherRow: (indexPath as NSIndexPath).row)
        } else if (self as NSIndexPath).section < (indexPath as NSIndexPath).section {
            return .before
        } else {
            return .ahead
        }
    }
}
