import ThemeDomain

package enum TokenName
{
    package static let prefix = "--manuscript-"

    package static func of(_ role: PaletteName) -> String
    {
        prefix + role.rawValue
    }

    package static func reference(_ role: PaletteName) -> String
    {
        "var(" + of(role) + ")"
    }
}
