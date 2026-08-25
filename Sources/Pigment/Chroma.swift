public struct Chroma: Hashable, Comparable, Sendable
{
    public static let none = Chroma(0)

    public let value: Double

    public init(_ value: Double)
    {
        self.value = value.isNaN ? 0 : max(value, 0)
    }

    public func scaled(by factor: Double) -> Chroma
    {
        Chroma(value * factor)
    }

    public func capped(at ceiling: Double) -> Chroma
    {
        Chroma(min(value, ceiling))
    }

    public static func < (one: Chroma, other: Chroma) -> Bool
    {
        one.value < other.value
    }
}
