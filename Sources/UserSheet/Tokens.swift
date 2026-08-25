import Cascade
import ThemeDomain

enum Tokens
{
    static func rule(for theme: Theme, on selectors: [String]) -> Rule
    {
        Rule(
            selectors,
            PaletteName.allCases.map
            {
                Declaration(TokenName.of($0), theme.palette.notation($0))
            })
    }
}
