import AppleColors
import Pigment

struct Theme: Sendable
{
    let preset: Preset
    let appearance: Appearance
    let palette: Palette

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

    var identifier: String
    {
        "\(preset.id)-\(appearance.rawValue)"
    }

    package var title: String
    {
        "\(preset.title) \(appearance.title)"
    }

    static func catalogue(
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
    var description: String
    {
        identifier
    }
}
