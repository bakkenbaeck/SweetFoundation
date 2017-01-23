import Foundation

public extension DispatchQueue {
    public func asyncAfter(seconds: Double, execute block: @escaping () -> Void) {
        let deadline: DispatchTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        self.asyncAfter(deadline: deadline, execute: block)
    }
}
