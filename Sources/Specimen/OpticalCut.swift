import Typography

package enum OpticalCut
{
    package static func serif(atPoints points: Double) -> Typeface
    {
        switch points
        {
        case ..<21: return .newYorkSmall
        case ..<29: return .newYorkMedium
        case ..<43: return .newYorkLarge
        default: return .newYorkExtraLarge
        }
    }
}
