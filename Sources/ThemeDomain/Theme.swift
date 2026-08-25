import AppleColors
import Pigment

public struct Theme: Sendable
{
    public let preset: Preset
    public let appearance: Appearance
    public let palette: Palette

    public init(
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

    public var identifier: String
    {
        "\(preset.id)-\(appearance.rawValue)"
    }

    public var title: String
    {
        "\(preset.title) \(appearance.title)"
    }

    public static func catalogue(
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
    public var description: String
    {
        identifier
    }
}
