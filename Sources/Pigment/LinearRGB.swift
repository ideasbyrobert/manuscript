import Foundation

public struct LinearRGB: Hashable, Sendable
{
    public let red: Double
    public let green: Double
    public let blue: Double

    public init(red: Double, green: Double, blue: Double)
    {
        self.red = red
        self.green = green
        self.blue = blue
    }

    public init(_ encoded: SRGB)
    {
        self.init(
            red: Self.expanded(encoded.red),
            green: Self.expanded(encoded.green),
            blue: Self.expanded(encoded.blue))
    }

    public var encoded: SRGB
    {
        SRGB(
            red: Self.compressed(red),
            green: Self.compressed(green),
            blue: Self.compressed(blue))
    }

    @inlinable
    static func expanded(_ component: Double) -> Double
    {
        component <= 0.04045
            ? component / 12.92
            : pow((component + 0.055) / 1.055, 2.4)
    }

    @inlinable
    static func compressed(_ component: Double) -> Double
    {
        component <= 0.0031308
            ? 12.92 * component
            : 1.055 * pow(component, 1 / 2.4) - 0.055
    }
}
