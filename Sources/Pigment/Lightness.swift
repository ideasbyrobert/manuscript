package struct Lightness: Hashable, Comparable, Sendable
{
    static let darkest = Lightness(0)
    static let lightest = Lightness(1)

    let value: Double

    package init(_ value: Double)
    {
        self.value = value.isNaN ? 0 : min(max(value, 0), 1)
    }

    package func adjusted(by delta: Double) -> Lightness
    {
        Lightness(value + delta)
    }

    func distance(to other: Lightness) -> Double
    {
        abs(value - other.value)
    }

    static func midpoint(
        _ one: Lightness,
        _ other: Lightness) -> Lightness
    {
        Lightness((one.value + other.value) / 2)
    }

    package static func < (one: Lightness, other: Lightness) -> Bool
    {
        one.value < other.value
    }
}
