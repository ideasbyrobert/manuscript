package enum TypeSlant: String, CaseIterable, Sendable
{
    case upright
    case italic

    package var suffix: String
    {
        self == .italic ? "Italic" : ""
    }
}
