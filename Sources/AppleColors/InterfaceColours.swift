import Pigment

package enum InterfaceColours
{
    package static let accent = SRGB(hexNotation: "#007AFF")!

    package static func selection(in appearance: Appearance) -> SRGB
    {
        switch appearance
        {
        case .light: return SRGB(hexNotation: "#B3D7FF")!
        case .dark: return SRGB(hexNotation: "#3F638B")!
        }
    }
}
