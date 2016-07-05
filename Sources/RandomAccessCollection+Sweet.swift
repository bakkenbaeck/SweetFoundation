import Foundation

extension CollectionType where Index == Int {

    typealias InternalElement = Generator.Element

    func enumerateWithNext() -> [(Generator.Element, Generator.Element?)] {
        let count = self.count
        var array = [(InternalElement, InternalElement?)]()

        for (index, item) in self.enumerate() {
            var nextItem: Generator.Element? = .None
            let nextIndex = index + 1

            if nextIndex < count {
                nextItem = self[nextIndex]
            }

            array.append((item, nextItem))
        }

        return array
    }

    func enumerateWithPrevious() -> [(Generator.Element?, Generator.Element)] {
        var array = [(InternalElement?, InternalElement)]()

        for (index, item) in self.enumerate() {
            var previousItem: Generator.Element? = nil
            let previousIndex = index - 1

            if previousIndex >= 0 && previousIndex < index {
                previousItem = self[previousIndex]
            }

            array.append((previousItem, item))
        }

        return array
    }
}
