import Foundation

struct OrderedSerializer {
    static func string(from leaf: Any) -> String {
        var string = ""
        if let leaf = leaf as? [String: Any] {
            string.append("{\(self.string(from: leaf))}")
        } else if let leaf = leaf as? [Any] {
            string.append("[\(self.string(from: leaf))]")
        } else {
            fatalError("Object could not be serialised. Make sure it's either a dictionary or an array.")
        }

        return string
    }

    private static func string(from leaf: [String: Any]) -> String {
        var string = ""
        let keys: [String] = (leaf.keys.map { k in return k }).sorted { a, b in a < b }
        for (index, key) in keys.enumerated() {
            guard let value = leaf[key] else { fatalError("WTF?") }

            if let value = value as? [String: Any] {
                string.append("\(key):{\(self.string(from: value))}")
            } else if let value = value as? [Any] {
                string.append("\(key):[\(self.string(from: value))]")
            } else {
                string.append("\(key):\"\(value)\"")
            }

            if index < (keys.count - 1) {
                string.append(",")
            }
        }

        return string
    }

    private static func string(from leaf: [Any]) -> String {
        var string = ""
        for (index, element) in leaf.enumerated() {
            if let element = element as? [String: Any] {
                string.append(self.string(from: element))
            } else if let element = element as? [Any] {
                string.append(self.string(from: element))
            } else {
                string.append("\"\(element)\"")

                if index < (leaf.count - 1) {
                    string.append(",")
                }
            }
        }
        
        return string
    }
}
