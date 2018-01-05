import Foundation

public extension Data {
    public func base64EncodedStringWithoutPadding() -> String {
        let base64 = self.base64EncodedString()
        
        if base64.hasSuffix("==") {
            return String(base64[base64.startIndex..<base64.index(base64.endIndex, offsetBy: -2)])
        } else if base64.hasSuffix("=") {
            return String(base64[base64.startIndex..<base64.index(base64.endIndex, offsetBy: -1)])
        }
        
        return base64
    }
    
    public func hexadecimalString() -> String {
        var hexString = ""
        for byte in [UInt8](self) {
            hexString += String(format: "%02lx", byte)
        }
        
        return hexString
    }
}
