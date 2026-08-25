import Pigment

public enum InterfaceColours
{
    public static let accent = SRGB(hexNotation: "#007AFF")!

    public static func selection(in appearance: Appearance) -> SRGB
    {
        switch appearance
        {
        case .light: return SRGB(hexNotation: "#B3D7FF")!
        case .dark: return SRGB(hexNotation: "#3F638B")!
        }
    }
}
