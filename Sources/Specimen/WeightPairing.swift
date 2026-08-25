import AppleColors
import Typography

package enum WeightPairing
{
    package static func body(on appearance: Appearance) -> TypeWeight
    {
        appearance == .dark ? .medium : .regular
    }

    package static func emphasis(on appearance: Appearance) -> TypeWeight
    {
        appearance == .dark ? .bold : .semibold
    }

    package static func numeric(_ weight: TypeWeight) -> Int
    {
        switch weight
        {
        case .ultralight: return 100
        case .thin: return 200
        case .light: return 300
        case .regular: return 400
        case .medium: return 500
        case .semibold: return 600
        case .bold: return 700
        case .heavy: return 800
        case .black: return 900
        }
    }
}
