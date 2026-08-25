import Foundation

package struct SRGB: Hashable, Sendable, CustomStringConvertible
{
    package let red: Double
    package let green: Double
    package let blue: Double

    package init(red: Double, green: Double, blue: Double)
    {
        self.red = red
        self.green = green
        self.blue = blue
    }

    package init?(hexNotation: String)
    {
        var digits = Substring(hexNotation)
        if digits.hasPrefix("#")
        {
            digits = digits.dropFirst()
        }
        guard digits.count == 6, let packed = UInt32(digits, radix: 16) else
        {
            return nil
        }
        self.init(
            red: Double((packed >> 16) & 0xFF) / 255,
            green: Double((packed >> 8) & 0xFF) / 255,
            blue: Double(packed & 0xFF) / 255)
    }

    package var hexNotation: String
    {
        let bounded = clipped
        return String(
            format: "#%02x%02x%02x",
            bounded.channel(bounded.red),
            bounded.channel(bounded.green),
            bounded.channel(bounded.blue))
    }

    package var quantised: SRGB
    {
        let bounded = clipped
        return SRGB(
            red: Double(bounded.channel(bounded.red)) / 255,
            green: Double(bounded.channel(bounded.green)) / 255,
            blue: Double(bounded.channel(bounded.blue)) / 255)
    }

    var clipped: SRGB
    {
        SRGB(
            red: confine(red),
            green: confine(green),
            blue: confine(blue))
    }

    var isWithinGamut: Bool
    {
        [red, green, blue].allSatisfy { $0 >= 0 && $0 <= 1 }
    }

    func isWithinGamut(tolerating slack: Double) -> Bool
    {
        [red, green, blue].allSatisfy { $0 >= -slack && $0 <= 1 + slack }
    }

    package var description: String
    {
        hexNotation
    }

    private func confine(_ component: Double) -> Double
    {
        min(max(component, 0), 1)
    }

    private func channel(_ component: Double) -> Int
    {
        Int((component * 255).rounded())
    }
}
