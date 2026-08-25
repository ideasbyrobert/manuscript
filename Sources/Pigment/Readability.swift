import Foundation

package struct Readability: Hashable, Comparable, Sendable
{
    private static let redWeight = 0.2126729
    private static let greenWeight = 0.7151522
    private static let blueWeight = 0.0721750
    private static let decoding = 2.4

    private static let blackThreshold = 0.022
    private static let blackClamp = 1.414
    private static let leastDifference = 0.0005

    private static let groundOnLight = 0.56
    private static let inkOnLight = 0.57
    private static let groundOnDark = 0.65
    private static let inkOnDark = 0.62

    private static let scale = 1.14
    private static let clip = 0.1
    private static let offset = 0.027

    package let value: Double

    package init(_ value: Double)
    {
        self.value = value
    }

    package var magnitude: Double
    {
        abs(value)
    }

    package static func between(_ ink: SRGB, _ ground: SRGB)
        -> Readability
    {
        let inkLight = flare(luminance(ink))
        let groundLight = flare(luminance(ground))
        guard abs(groundLight - inkLight) >= leastDifference else
        {
            return Readability(0)
        }
        if groundLight > inkLight
        {
            let found = (pow(groundLight, groundOnLight)
                - pow(inkLight, inkOnLight)) * scale
            return Readability(found < clip ? 0 : (found - offset) * 100)
        }
        let found = (pow(groundLight, groundOnDark)
            - pow(inkLight, inkOnDark)) * scale
        return Readability(found > -clip ? 0 : (found + offset) * 100)
    }

    package static func < (one: Readability, other: Readability) -> Bool
    {
        one.value < other.value
    }

    private static func luminance(_ colour: SRGB) -> Double
    {
        let bounded = colour.clipped
        return redWeight * pow(bounded.red, decoding)
            + greenWeight * pow(bounded.green, decoding)
            + blueWeight * pow(bounded.blue, decoding)
    }

    private static func flare(_ light: Double) -> Double
    {
        light > blackThreshold
            ? light
            : light + pow(blackThreshold - light, blackClamp)
    }
}
