import ThemeDomain

enum TokenName
{
    private static let prefix = "--manuscript-"

    static func of(_ role: PaletteName) -> String
    {
        prefix + role.rawValue
    }

    static func reference(_ role: PaletteName) -> String
    {
        "var(" + of(role) + ")"
    }
}
