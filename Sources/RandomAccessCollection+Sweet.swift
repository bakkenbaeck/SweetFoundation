import Foundation

extension CollectionType {
    func enumerateWithNext() -> [(Any, Any?)] {
        let count = self.count as! Int
        var array = [(Any, Any?)]()

        for (index, item) in self.enumerate() {
            var nextItem: Any? = nil
            let nextIndex = index + 1

            if nextIndex <  count {
                nextItem = self[nextIndex as! Index]
            }

            array.append((item, nextItem))
        }
        return array
    }
}
