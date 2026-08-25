import Cascade
import ThemeDomain

package enum UserStyleSheet
{
    package static func sheet(for pair: ThemePair) -> StyleSheet
    {
        StyleSheet(
            [
                .rule(Tokens.rule(for: pair.light, on: [":root"])),
                .when(
                    .dark,
                    [.rule(Tokens.rule(for: pair.dark, on: [":root"]))]),
                .rule(Tokens.rule(for: pair.dark, on: SiteScheme.dark)),
                .rule(Tokens.rule(for: pair.light, on: SiteScheme.light))
            ]
            + CodeSurface.blocks)
            .userOrigin
    }
}
