import Foundation

extension URLRequest {
    public func debugLog() -> String {
        var description = "\(self)"
        if let headers = self.allHTTPHeaderFields {
            description.append("\n\(headers)")
        }
        if let httpBody = self.httpBody, let dataString = String(data: httpBody, encoding: .utf8) {
            description.append("\n\(dataString)")
        }

        return description
    }
}
