import Foundation

extension URLRequest {
    public var debugDescription: String {
        var description = "\(self)"
        if let headers = self.allHTTPHeaderFields {
            description.append("\n\(headers)")
        }
        if let httpBody = self.httpBody, let dataString = String(data: httpBody, encoding: String.Encoding.utf8) {
            description.append("\n\(dataString)")
        }

        return description
    }
}