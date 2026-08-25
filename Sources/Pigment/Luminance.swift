public struct Luminance: Sendable
{
    public let value: Double

    public init(_ colour: SRGB)
    {
        let linear = LinearRGB(colour)
        value = 0.2126 * linear.red
            + 0.7152 * linear.green
            + 0.0722 * linear.blue
    }
}
