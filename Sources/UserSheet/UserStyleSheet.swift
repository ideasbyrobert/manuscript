import Cascade
import ThemeDomain

package enum UserStyleSheet
{
    package static func sheet(for pair: ThemePair) -> StyleSheet
    {
        StyleSheet(
            [
                .rule(scheme),
                .rule(Tokens.rule(for: pair.light)),
                .when(.dark, [.rule(Tokens.rule(for: pair.dark))])
            ]
            + CodeSurface.blocks)
            .userOrigin
    }

    private static var scheme: Rule
    {
        Rule(
            ["html", ":root"],
            [Declaration("color-scheme", "light dark")])
    }
}
