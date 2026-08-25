package enum Typeface: String, CaseIterable, Sendable
{
    case newYorkSmall
    case newYorkMedium
    case newYorkLarge
    case newYorkExtraLarge
    case sfPro
    case sfProText
    case sfProDisplay
    case sfCompact
    case sfCompactText
    case sfCompactDisplay
    case sfMono

    package var stem: String
    {
        switch self
        {
        case .newYorkSmall: return "NewYorkSmall"
        case .newYorkMedium: return "NewYorkMedium"
        case .newYorkLarge: return "NewYorkLarge"
        case .newYorkExtraLarge: return "NewYorkExtraLarge"
        case .sfPro: return "SFPro"
        case .sfProText: return "SFProText"
        case .sfProDisplay: return "SFProDisplay"
        case .sfCompact: return "SFCompact"
        case .sfCompactText: return "SFCompactText"
        case .sfCompactDisplay: return "SFCompactDisplay"
        case .sfMono: return "SFMono"
        }
    }

    package var weights: [TypeWeight]
    {
        switch self
        {
        case .newYorkSmall, .newYorkMedium, .newYorkLarge,
             .newYorkExtraLarge:
            return [.regular, .medium, .semibold, .bold, .heavy, .black]
        case .sfMono:
            return [.light, .regular, .medium, .semibold, .bold, .heavy]
        case .sfPro, .sfProText, .sfProDisplay, .sfCompact,
             .sfCompactText, .sfCompactDisplay:
            return TypeWeight.allCases
        }
    }

    package var carriesItalics: Bool
    {
        self != .sfCompactDisplay
    }

    package var isFixedPitch: Bool
    {
        self == .sfMono
    }
}
