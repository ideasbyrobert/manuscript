package enum MediaCondition: String, Sendable, CaseIterable
{
    case light
    case dark

    var text: String
    {
        "(prefers-color-scheme: \(rawValue))"
    }
}
