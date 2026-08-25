import Cascade
import ThemeDomain

enum Tokens
{
    static func rule(for theme: Theme) -> Rule
    {
        Rule(
            [":root"],
            PaletteName.allCases.map
            {
                Declaration(TokenName.of($0), theme.palette.notation($0))
            })
    }
}
