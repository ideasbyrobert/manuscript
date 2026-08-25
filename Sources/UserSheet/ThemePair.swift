import AppleColors
import ThemeDomain

package struct ThemePair: Sendable
{
    package let light: Theme
    package let dark: Theme

    package init?(preset: String, in themes: [Theme])
    {
        guard let light = themes.first(where:
        {
            $0.identifier == preset + "-light"
        }),
        let dark = themes.first(where:
        {
            $0.identifier == preset + "-dark"
        })
        else
        {
            return nil
        }
        self.light = light
        self.dark = dark
    }

    package var name: String
    {
        String(light.identifier.dropLast("-light".count))
    }

    package static func all(in themes: [Theme]) -> [ThemePair]
    {
        themes
            .filter { $0.appearance == .light }
            .compactMap
            {
                ThemePair(
                    preset: String(
                        $0.identifier.dropLast("-light".count)),
                    in: themes)
            }
    }
}
