package enum MediaCondition: String, Sendable, CaseIterable
{
    case light
    case dark

    package var text: String
    {
        "(prefers-color-scheme: \(rawValue))"
    }
}
