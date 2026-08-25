import Foundation

public struct Hue: Hashable, Sendable
{
    public let degrees: Double

    public init(degrees: Double)
    {
        let wrapped = degrees.truncatingRemainder(dividingBy: 360)
        self.degrees = wrapped < 0 ? wrapped + 360 : wrapped
    }

    public var radians: Double
    {
        degrees * .pi / 180
    }

    public func separation(from other: Hue) -> Double
    {
        let gap = abs(degrees - other.degrees)
        return min(gap, 360 - gap)
    }
}
