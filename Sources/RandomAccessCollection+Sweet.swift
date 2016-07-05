import Foundation

extension Array {

    func enumerateWithNext() -> [(Element, Element?)] {
        let count = self.count
        var array = [(Element, Element?)]()

        for (index, item) in self.enumerate() {
            var nextItem: Element? = .None
            let nextIndex = index + 1

            if nextIndex <  count {
                nextItem = self[nextIndex]
            }

            array.append((item, nextItem))
        }

        return array
    }

    func enumerateWithPrevious() -> [(Element?, Element)] {
        var array = [(Element?, Element)]()

        for (index, item) in self.enumerate() {
            var previousItem: Element? = nil
            let previousIndex = index - 1

            if previousIndex >= 0 && previousIndex < index {
                previousItem = self[previousIndex]
            }

            array.append((previousItem, item))
        }

        return array
    }
}
