public struct Lightness: Hashable, Comparable, Sendable
{
    public static let darkest = Lightness(0)
    public static let lightest = Lightness(1)

    public let value: Double

    public init(_ value: Double)
    {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }

    public func adjusted(by delta: Double) -> Lightness
    {
        Lightness(value + delta)
    }

    public func distance(to other: Lightness) -> Double
    {
        abs(value - other.value)
    }

    public static func midpoint(
        _ one: Lightness,
        _ other: Lightness) -> Lightness
    {
        Lightness((one.value + other.value) / 2)
    }

    public static func < (one: Lightness, other: Lightness) -> Bool
    {
        one.value < other.value
    }
}
