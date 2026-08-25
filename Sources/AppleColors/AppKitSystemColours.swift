import AppKit
import Pigment

public struct AppKitSystemColours: SystemColourSource
{
    public init() {}

    public func colour(
        _ colour: SystemColour,
        in appearance: Appearance) -> SRGB
    {
        var sampled = SRGB(red: 0.5, green: 0.5, blue: 0.5)
        let named: NSAppearance.Name =
            appearance == .dark ? .darkAqua : .aqua
        NSAppearance(named: named)?.performAsCurrentDrawingAppearance
        {
            sampled = Self.sample(Self.appKitColour(for: colour))
        }
        return sampled
    }

    static func appKitColour(for colour: SystemColour) -> NSColor
    {
        switch colour
        {
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .yellow: return .systemYellow
        case .green: return .systemGreen
        case .mint: return .systemMint
        case .teal: return .systemTeal
        case .cyan: return .systemCyan
        case .blue: return .systemBlue
        case .indigo: return .systemIndigo
        case .purple: return .systemPurple
        case .pink: return .systemPink
        case .brown: return .systemBrown
        case .gray: return .systemGray
        }
    }

    static func sample(_ colour: NSColor) -> SRGB
    {
        guard let converted = colour.usingColorSpace(.sRGB) else
        {
            return SRGB(red: 0.5, green: 0.5, blue: 0.5)
        }
        return SRGB(
            red: Double(converted.redComponent),
            green: Double(converted.greenComponent),
            blue: Double(converted.blueComponent))
    }
}
