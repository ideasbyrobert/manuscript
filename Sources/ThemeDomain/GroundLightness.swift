import AppleColors
import Pigment

enum GroundLightness
{
    package static func of(_ appearance: Appearance) -> Lightness
    {
        switch appearance
        {
        case .light: return Lightness(0.9800)
        case .dark: return Lightness(0.2080)
        }
    }

    static func tintShare(for appearance: Appearance) -> Double
    {
        appearance == .dark ? 0.150 : 0.150
    }
}
