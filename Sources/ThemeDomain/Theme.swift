import AppleColors
import Pigment

package struct Theme: Sendable
{
    let preset: Preset
    package let appearance: Appearance
    package let palette: Palette

    init(
        preset: Preset,
        appearance: Appearance,
        systemColours: any SystemColourSource = RecordedSystemColours.macOS27)
    {
        self.preset = preset
        self.appearance = appearance
        palette = PaletteResolver(
            preset: preset,
            appearance: appearance,
            systemColours: systemColours).resolve()
    }

    package var identifier: String
    {
        "\(preset.id)-\(appearance.rawValue)"
    }

    package var title: String
    {
        "\(preset.title) \(appearance.title)"
    }

    package static func catalogue(
        systemColours: any SystemColourSource = RecordedSystemColours.macOS27)
        -> [Theme]
    {
        PresetCatalog.all.flatMap
        { preset in
            Appearance.allCases.map
            {
                Theme(
                    preset: preset,
                    appearance: $0,
                    systemColours: systemColours)
            }
        }
    }
}

extension Theme: CustomStringConvertible
{
    package var description: String
    {
        identifier
    }
}
