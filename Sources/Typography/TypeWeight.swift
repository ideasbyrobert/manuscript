package enum TypeWeight: String, CaseIterable, Sendable
{
    case ultralight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    package var suffix: String
    {
        switch self
        {
        case .ultralight: return "Ultralight"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        }
    }
}
