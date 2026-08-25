import Cascade
import ThemeDomain

package enum Tokens
{
    package static func rule(for theme: Theme) -> Rule
    {
        Rule(
            [":root"],
            PaletteName.allCases.map
            {
                Declaration(TokenName.of($0), theme.palette.notation($0))
            })
    }
}
