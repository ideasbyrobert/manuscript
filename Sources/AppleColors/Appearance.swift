public enum Appearance: String, CaseIterable, Sendable
{
    case light
    case dark

    public var title: String
    {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

    public var opposite: Appearance
    {
        self == .light ? .dark : .light
    }
}
