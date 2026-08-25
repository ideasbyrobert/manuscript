import Cascade
import ThemeDomain

package enum UserStyleSheet
{
    package static func sheet(for pair: ThemePair) -> StyleSheet
    {
        let roles = CodeSurface.roles
        let light = pair.light
        let dark = pair.dark
        return StyleSheet(
            [
                .rule(Tokens.rule(for: light, on: [":root"], roles: roles)),
                .when(
                    .dark,
                    [
                        .rule(
                            Tokens.rule(for: dark, on: [":root"], roles: roles))
                    ]),
                .rule(
                    Tokens.rule(for: dark, on: SiteScheme.dark, roles: roles)),
                .rule(
                    Tokens.rule(for: light, on: SiteScheme.light, roles: roles))
            ]
            + CodeSurface.blocks)
            .userOrigin
    }
}
