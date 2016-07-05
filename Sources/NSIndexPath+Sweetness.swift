import UIKit

public extension NSIndexPath {
    public enum Direction {
        case Same
        case Before
        case Ahead
    }

    private func comparePosition(ownRow: Int, otherRow: Int) -> Direction {
        if ownRow == otherRow {
            return .Same
        } else if ownRow < otherRow {
            return .Before
        } else {
            return .Ahead
        }
    }

    public func comparePosition(to indexPath: NSIndexPath) -> Direction {
        if self.section == indexPath.section {
            return self.comparePosition(self.row, otherRow: indexPath.row)
        } else if self.section < indexPath.section {
            return .Before
        } else {
            return .Ahead
        }
    }

    public func indexPaths(collectionView collectionView: UICollectionView) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()

        let sections = collectionView.numberOfSections()
        for section in 0..<sections {
            let rows = collectionView.numberOfItemsInSection(section)
            for row in 0..<rows {
                indexPaths.append(NSIndexPath(forRow: row, inSection: section))
            }
        }

        return indexPaths
    }

    public func next(collectionView collectionView: UICollectionView) -> NSIndexPath? {
        var found = false
        let indexPaths = self.indexPaths(collectionView: collectionView)
        for indexPath in indexPaths {
            if found == true {
                return indexPath
            }

            if indexPath == self {
                found = true
            }
        }

        return nil
    }

    public func previous(collectionView collectionView: UICollectionView) -> NSIndexPath? {
        var previousIndexPath: NSIndexPath?
        let indexPaths = self.indexPaths(collectionView: collectionView)
        for indexPath in indexPaths {
            if indexPath == self {
                return previousIndexPath
            }

            previousIndexPath = indexPath
        }

        return nil
    }

    public class func firstIndexPathForIndex(collectionView collectionView: UICollectionView, index: Int) -> NSIndexPath? {
        var count = 0
        let sections = collectionView.numberOfSections()
        for section in 0..<sections {
            let rows = collectionView.numberOfItemsInSection(section)
            if index >= count && index < count + rows {
                let foundRow = index - count
                return NSIndexPath(forRow: foundRow, inSection: section)
            }
            count += rows
        }

        return nil
    }

    public func totalRowCount(collectionView collectionView: UICollectionView) -> Int {
        var count = 0
        let sections = collectionView.numberOfSections()
        for section in 0..<sections {
            if section < self.section {
                let rows = collectionView.numberOfItemsInSection(section)
                count += rows
            }
        }

        return count + self.row
    }
}
