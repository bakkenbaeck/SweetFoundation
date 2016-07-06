import Foundation

extension CollectionType where Index == Int {

    typealias InternalElement = Generator.Element

    func enumeratedWithNext() -> [(Generator.Element, Generator.Element)] {
        let count: Int = self.count
        var array = [(InternalElement, InternalElement)]()

        for (index, item) in self.enumerate() {
            var nextItem: Generator.Element? = .None
            let nextIndex = index + 1

            if nextIndex < count {
                nextItem = self[nextIndex]
                array.append((item, nextItem!))
            }
        }

        return array
    }
}
