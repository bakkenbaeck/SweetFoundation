import Foundation

public struct Math {
    public static func degreesToRadians(_ degrees: Double) -> Double {
        return Double.pi * degrees / 180.0
    }

    public static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / Double.pi
    }
}
