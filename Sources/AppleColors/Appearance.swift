package enum Appearance: String, CaseIterable, Sendable
{
    case light
    case dark

    package var title: String
    {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

    var opposite: Appearance
    {
        self == .light ? .dark : .light
    }
}
