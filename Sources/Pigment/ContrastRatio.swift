public struct ContrastRatio: Hashable, Comparable, Sendable
{
    public let value: Double

    public init(_ value: Double)
    {
        self.value = value
    }

    public static func between(_ ink: SRGB, _ ground: SRGB) -> ContrastRatio
    {
        let one = Luminance(ink).value
        let other = Luminance(ground).value
        let lighter = max(one, other)
        let darker = min(one, other)
        return ContrastRatio((lighter + 0.05) / (darker + 0.05))
    }

    public static func < (one: ContrastRatio, other: ContrastRatio) -> Bool
    {
        one.value < other.value
    }
}

extension ContrastRatio: ExpressibleByFloatLiteral
{
    public init(floatLiteral value: Double)
    {
        self.init(value)
    }
}
