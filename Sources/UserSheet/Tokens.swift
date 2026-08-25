import Cascade
import ThemeDomain

enum Tokens
{
    static func rule(
        for theme: Theme,
        on selectors: [String],
        roles: [PaletteName]) -> Rule
    {
        Rule(
            selectors,
            roles.map
            {
                Declaration(TokenName.of($0), theme.palette.notation($0))
            })
    }
}
