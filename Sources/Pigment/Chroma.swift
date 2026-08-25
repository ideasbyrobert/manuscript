package struct Chroma: Hashable, Comparable, Sendable
{
    static let none = Chroma(0)

    let value: Double

    package init(_ value: Double)
    {
        self.value = value.isNaN ? 0 : max(value, 0)
    }

    package func scaled(by factor: Double) -> Chroma
    {
        Chroma(value * factor)
    }

    package func capped(at ceiling: Double) -> Chroma
    {
        Chroma(min(value, ceiling))
    }

    package static func < (one: Chroma, other: Chroma) -> Bool
    {
        one.value < other.value
    }
}
