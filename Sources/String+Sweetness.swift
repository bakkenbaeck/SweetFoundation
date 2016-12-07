import Foundation

public extension String {
    public var isValidEmail: Bool {
        let emailRegEx = ".*@.*"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
