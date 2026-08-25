import AppleColors
import Pigment

public enum GroundLightness
{
    public static func of(_ appearance: Appearance) -> Lightness
    {
        switch appearance
        {
        case .light: return Lightness(0.9800)
        case .dark: return Lightness(0.2080)
        }
    }

    public static func tintCeiling(for appearance: Appearance) -> Double
    {
        appearance == .dark ? 0.034 : 0.028
    }
}
